function Test-NinjaOneEndpointSupport {
	<#
		.SYNOPSIS
			Validates whether an API endpoint is supported by the connected instance.
		.DESCRIPTION
			Uses the OpenAPI spec for the connected instance to confirm the endpoint exists and the method is supported.
	#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSMissingParameterInlineComment', '', Justification = 'Internal private function does not require parameter descriptions.')]
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[String]$method,
		[Parameter(Mandatory)]
		[String]$resource
	)

	if (-not $Script:NRAPIInstanceCapabilityCheckEnabled) {
		Write-Verbose 'Endpoint capability checks are disabled. Skipping validation.'
		return $true
	}

	if ($null -eq $Script:NRAPIConnectionInformation -or [string]::IsNullOrWhiteSpace($Script:NRAPIConnectionInformation.URL)) {
		return $true
	}

	$baseUrl = $Script:NRAPIConnectionInformation.URL
	if ($baseUrl -notmatch 'ninjarmm\.com') {
		return $true
	}

	$capabilities = Get-NinjaOneInstanceCapabilitiesInternal -BaseUrl $baseUrl
	if ($null -eq $capabilities) {
		return $true
	}

	$path = $resource
	if (-not $path.StartsWith('/')) {
		$path = '/' + $path
	}
	$path = $path.Split('?')[0]
	if ($path.Length -gt 1) {
		$path = $path.TrimEnd('/')
	}
	$methodKey = $method.ToUpperInvariant()
	$paths = $capabilities.Paths
	$testPathSupport = {
		param($pathsToCheck, $pathToCheck, $methodToCheck)
		if ($pathsToCheck.ContainsKey($pathToCheck)) {
			$methods = $pathsToCheck[$pathToCheck]
			$methodUnknown = ($methods.Count -eq 0)
			$ok = ($methodUnknown -or $methods.Contains($methodToCheck))
			return [pscustomobject]@{
				Supported = $ok
				MatchedPath = $pathToCheck
				Methods = $methods
				MethodUnknown = $methodUnknown
			}
		}

		foreach ($openPath in $pathsToCheck.Keys) {
			$normalizedOpenPath = if ($openPath.Length -gt 1) { $openPath.TrimEnd('/') } else { $openPath }
			$pattern = '^' + ($normalizedOpenPath -replace '\{[^}]+\}', '[^/]+') + '$'
			if ($pathToCheck -match $pattern) {
				$methods = $pathsToCheck[$openPath]
				$methodUnknown = ($methods.Count -eq 0)
				$ok = ($methodUnknown -or $methods.Contains($methodToCheck))
				return [PSCustomObject]@{
					Supported = $ok
					MatchedPath = $openPath
					Methods = $methods
					MethodUnknown = $methodUnknown
				}
			}
		}

		return [PSCustomObject]@{
			Supported = $false
			MatchedPath = $null
			Methods = $null
			MethodUnknown = $false
		}
	}

	$match = & $testPathSupport $paths $path $methodKey
	if ($match.Supported) {
		$matchedPath = if ($match.MatchedPath) { $match.MatchedPath } else { $path }
		$matchedMethods = if ($match.Methods) { ($match.Methods -join ', ') } else { 'unknown' }
		if ($match.MethodUnknown) {
			Write-Verbose ('Endpoint support assumed for ''{0}'' ({1}). Matched spec path ''{2}'' has no methods listed.' -f $path, $methodKey, $matchedPath)
		} else {
			Write-Verbose ('Endpoint support confirmed for ''{0}'' ({1}). Matched spec path ''{2}'' with methods: {3}.' -f $path, $methodKey, $matchedPath, $matchedMethods)
		}
		return $true
	}

	$refreshed = Get-NinjaOneInstanceCapabilitiesInternal -BaseUrl $baseUrl -Force
	if ($refreshed -and $refreshed.Paths) {
		$refreshedMatch = & $testPathSupport $refreshed.Paths $path $methodKey
		if ($refreshedMatch.Supported) {
			$matchedPath = if ($refreshedMatch.MatchedPath) { $refreshedMatch.MatchedPath } else { $path }
			$matchedMethods = if ($refreshedMatch.Methods) { ($refreshedMatch.Methods -join ', ') } else { 'unknown' }
			if ($refreshedMatch.MethodUnknown) {
				Write-Verbose ('Endpoint support assumed after refresh for ''{0}'' ({1}). Matched spec path ''{2}'' has no methods listed.' -f $path, $methodKey, $matchedPath)
			} else {
				Write-Verbose ('Endpoint support confirmed after refresh for ''{0}'' ({1}). Matched spec path ''{2}'' with methods: {3}.' -f $path, $methodKey, $matchedPath, $matchedMethods)
			}
			return $true
		}
	}

	$pathsToInspect = if ($refreshed -and $refreshed.Paths) { $refreshed.Paths } else { $paths }
	Write-Verbose ('Entering fallback path-only match. PathsToInspect is null: {0}. Count: {1}. Keys count: {2}. Type: {3}' -f ($null -eq $pathsToInspect), $pathsToInspect.Count, $pathsToInspect.Keys.Count, $pathsToInspect.GetType().Name)
	$specPathKeys = @($pathsToInspect.Keys)
	Write-Verbose ('Extracted {0} keys from pathsToInspect. First 5: {1}' -f $specPathKeys.Count, (($specPathKeys | Select-Object -First 5) -join ', '))
	foreach ($openPath in $specPathKeys) {
		$normalizedOpenPath = if ($openPath.Length -gt 1) { $openPath.TrimEnd('/') } else { $openPath }
		$pattern = '^' + ($normalizedOpenPath -replace '\{[^}]+\}', '[^/]+') + '$'
		Write-Verbose ('Testing spec path ''{0}'' (normalized: ''{1}'') with pattern ''{2}'' against request path ''{3}''' -f $openPath, $normalizedOpenPath, $pattern, $path)
		if ($path -match $pattern) {
			Write-Verbose ('FALLBACK MATCH: Endpoint path ''{0}'' matches spec path ''{1}'', but method ''{2}'' is not listed. Allowing call.' -f $path, $openPath, $methodKey)
			return $true
		}
	}
	Write-Verbose ('Fallback path-only match failed. No spec paths matched request path ''{0}''.' -f $path)

	$instanceHost = $baseUrl
	try {
		$instanceHost = ([uri]$baseUrl).Host
	} catch {
		$instanceHost = $baseUrl
	}
	$versionSuffix = if ($capabilities.Version) { (' (app version {0})' -f $capabilities.Version) } else { '' }
	$matchInfo = $null
	if ($refreshedMatch -and $refreshedMatch.MatchedPath) {
		$matchInfo = $refreshedMatch
	} elseif ($match.MatchedPath) {
		$matchInfo = $match
	}
	$methodInfo = ''
	if ($matchInfo) {
		if ($matchInfo.Methods -and $matchInfo.Methods.Count -gt 0) {
			$methodInfo = (' Matched spec path ''{0}'' with methods: {1}.' -f $matchInfo.MatchedPath, ($matchInfo.Methods -join ', '))
		} else {
			$methodInfo = (' Matched spec path ''{0}'' with no methods listed.' -f $matchInfo.MatchedPath)
		}
	}
	$candidatePaths = @($pathsToInspect.Keys | Where-Object { $_ -match '/organization/' -and $_ -match '/custom-fields' })
	$candidateInfo = ''
	if ($candidatePaths.Count -gt 0) {
		$candidateInfo = (' Spec paths containing organization custom-fields: {0}.' -f ($candidatePaths -join ', '))
	}
	$pathCountInfo = (' Spec path count: {0}.' -f $pathsToInspect.Count)
	throw ('The endpoint ''{0}'' ({1}) is not listed in the NinjaOne API spec for instance ''{2}''{3}.{4}{5}{6} This cmdlet may not be supported on that instance.' -f $path, $methodKey, $instanceHost, $versionSuffix, $methodInfo, $pathCountInfo, $candidateInfo)
}
