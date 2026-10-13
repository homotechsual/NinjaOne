function Get-NinjaOneInstanceCapabilitiesInternal {
	<#
		.SYNOPSIS
			Retrieves and caches instance API capabilities.
		.DESCRIPTION
			Downloads the instance app version and OpenAPI spec, then caches the supported paths and methods.
		.OUTPUTS
			[PSCustomObject]
	#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSMissingParameterInlineComment', '', Justification = 'Internal private function does not require parameter descriptions.')]
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[String]$baseUrl,
		[Switch]$force
	)

	$cacheKey = $baseUrl.TrimEnd('/')
	if (-not $force -and $Script:NRAPIInstanceCapabilities.ContainsKey($cacheKey)) {
		return $Script:NRAPIInstanceCapabilities[$cacheKey]
	}

	$version = $null
	$yaml = $null
	try {
		$versionContent = (Invoke-WebRequest -Uri ("{0}/app-version.txt" -f $cacheKey) -UseBasicParsing -ErrorAction Stop).Content
		if ($versionContent -is [byte[]]) {
			$versionContent = [System.Text.Encoding]::UTF8.GetString($versionContent)
		}
		$versionText = ([string]$versionContent).Trim()
		if ($versionText -match '^\d+(?:\.\d+){1,3}(?:[-+][0-9A-Za-z][0-9A-Za-z.+-]*)?$') {
			$version = $versionText
		} else {
			Write-Warning ('Instance {0} returned an invalid app version response; app version is unavailable.' -f $cacheKey)
		}
	} catch {
		Write-Warning ('Unable to retrieve app version from {0}: {1}' -f $cacheKey, $_.Exception.Message)
	}

	try {
		$yamlContent = (Invoke-WebRequest -Uri ("{0}/apidocs-beta/NinjaRMM-API-v2.yaml" -f $cacheKey) -UseBasicParsing -ErrorAction Stop).Content
		$yaml = if ($yamlContent -is [byte[]]) {
			[System.Text.Encoding]::UTF8.GetString($yamlContent)
		} else {
			[string]$yamlContent
		}
	} catch {
		return $null
	}

	$paths = Get-NinjaOneOpenApiPaths -OpenApiYaml $yaml
	$capabilities = [PSCustomObject]@{
		BaseUrl = $cacheKey
		Version = $version
		SpecUrl = ("{0}/apidocs-beta/NinjaRMM-API-v2.yaml" -f $cacheKey)
		RetrievedAt = Get-Date
		Paths = $paths
	}

	$Script:NRAPIInstanceCapabilities[$cacheKey] = $capabilities
	return $capabilities
}
