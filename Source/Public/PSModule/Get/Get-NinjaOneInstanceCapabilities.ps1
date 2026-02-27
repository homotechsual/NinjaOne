function Get-NinjaOneInstanceCapabilities {
	<#
		.SYNOPSIS
			Gets API capability information for a NinjaOne instance.
		.DESCRIPTION
			Downloads the instance app version and OpenAPI spec, then reports supported endpoints.
		.FUNCTIONALITY
			Tooling
		.EXAMPLE
			PS> Get-NinjaOneInstanceCapabilities

			Gets capabilities for the currently connected instance.
		.EXAMPLE
			PS> Get-NinjaOneInstanceCapabilities -Instance 'fed' -IncludeCmdlets

			Gets capabilities and cmdlet support for the fed instance.
		.EXAMPLE
			PS> Get-NinjaOneInstanceCapabilities -BaseUrl 'https://fed.ninjarmm.com' -Refresh

			Forces a refresh of cached capabilities for a specific instance URL.
		.OUTPUTS
			A PowerShell object describing instance capabilities.
	#>
	[CmdletBinding()]
	[OutputType([PSCustomObject])]
	param(
		# Instance short name (eu, oc, us, app, ca, us2, fed).
		[ValidateSet('eu', 'oc', 'us', 'app', 'ca', 'us2', 'fed')]
		[String]$Instance,
		# Full base URL (https://<instance>.ninjarmm.com).
		[String]$BaseUrl,
		# Refresh cached capabilities for this instance.
		[Switch]$Refresh,
		# Include supported/unsupported cmdlet lists.
		[Switch]$IncludeCmdlets,
		# Include raw OpenAPI paths and methods.
		[Switch]$IncludePaths
	)

	$resolvedBaseUrl = $null
	if (-not [string]::IsNullOrWhiteSpace($BaseUrl)) {
		$resolvedBaseUrl = $BaseUrl
	} elseif (-not [string]::IsNullOrWhiteSpace($Instance)) {
		if ($Script:NRAPIInstances.ContainsKey($Instance)) {
			$resolvedBaseUrl = $Script:NRAPIInstances[$Instance]
		}
	} elseif ($Script:NRAPIConnectionInformation -and $Script:NRAPIConnectionInformation.URL) {
		$resolvedBaseUrl = $Script:NRAPIConnectionInformation.URL
	}

	if ([string]::IsNullOrWhiteSpace($resolvedBaseUrl)) {
		throw 'No instance selected. Provide -Instance, -BaseUrl, or connect first.'
	}

	$capabilities = Get-NinjaOneInstanceCapabilitiesInternal -BaseUrl $resolvedBaseUrl -Force:$Refresh
	if ($null -eq $capabilities) {
		throw "Unable to retrieve OpenAPI spec from '$resolvedBaseUrl'."
	}

	$summary = [ordered]@{
		Instance = $Instance
		BaseUrl = $capabilities.BaseUrl
		AppVersion = $capabilities.Version
		SpecUrl = $capabilities.SpecUrl
		RetrievedAt = $capabilities.RetrievedAt
		PathCount = $capabilities.Paths.Count
	}

	if ($IncludeCmdlets) {
		$moduleName = 'NinjaOne'
		$module = Get-Module -Name $moduleName -ErrorAction Stop
		$exportedFunctionNames = @($module.ExportedFunctions.Keys)
		$commands = @(Get-Command -Module $moduleName -CommandType Function | Where-Object { $_.Name -in $exportedFunctionNames })
		$supported = @()
		$unsupported = @()
		$unknown = @()

		$testPathSupport = {
			param($paths, $path, $method)

			if (-not $path.StartsWith('/')) {
				$path = '/' + $path
			}
			$methodKey = $method.ToUpperInvariant()

			if ($paths.ContainsKey($path)) {
				if ($paths[$path].Count -eq 0 -or $paths[$path].Contains($methodKey)) {
					return $true
				}
				return $false
			}

			foreach ($openPath in $paths.Keys) {
				$pattern = '^' + ($openPath -replace '\{[^}]+\}', '[^/]+') + '$'
				if ($path -match $pattern) {
					if ($paths[$openPath].Count -eq 0 -or $paths[$openPath].Contains($methodKey)) {
						return $true
					}
					return $false
				}
			}

			return $false
		}

		foreach ($command in $commands) {
			$attrs = @($command.ScriptBlock.Attributes | Where-Object { $_ -is [MetadataAttribute] })
			if (-not $attrs -or $attrs.Count -eq 0) {
				$unknown += $command.Name
				continue
			}

			$tags = @()
			foreach ($attr in $attrs) {
				$tags += $attr.GetTags()
			}
			if ($tags -contains 'IGNORE') {
				continue
			}

			$endpoints = @()
			for ($i = 0; $i -lt $tags.Count; $i += 2) {
				$path = $tags[$i]
				$method = $null
				if ($i + 1 -lt $tags.Count) {
					$method = $tags[$i + 1]
				}
				if ([string]::IsNullOrWhiteSpace($path) -or [string]::IsNullOrWhiteSpace($method)) {
					continue
				}
				$endpoints += [PSCustomObject]@{ Path = $path; Method = $method }
			}

			if ($endpoints.Count -eq 0) {
				$unknown += $command.Name
				continue
			}

			$paths = $capabilities.Paths
			$commandSupported = $false
			foreach ($endpoint in $endpoints) {
				if (& $testPathSupport $paths $endpoint.Path $endpoint.Method) {
					$commandSupported = $true
					break
				}
			}

			if ($commandSupported) {
				$supported += $command.Name
			} else {
				$unsupported += $command.Name
			}
		}

		$summary.SupportedCmdlets = $supported | Sort-Object
		$summary.UnsupportedCmdlets = $unsupported | Sort-Object
		$summary.UnknownCmdlets = $unknown | Sort-Object
		$summary.SupportedCmdletCount = $supported.Count
		$summary.UnsupportedCmdletCount = $unsupported.Count
		$summary.UnknownCmdletCount = $unknown.Count
	}

	if ($IncludePaths) {
		$summary.Paths = $capabilities.Paths
	}

	return [PSCustomObject]$summary
}
