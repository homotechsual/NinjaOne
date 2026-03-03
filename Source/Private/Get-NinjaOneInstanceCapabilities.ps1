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
		[String]$BaseUrl,
		[Switch]$Force
	)

	$cacheKey = $BaseUrl.TrimEnd('/')
	if (-not $Force -and $Script:NRAPIInstanceCapabilities.ContainsKey($cacheKey)) {
		return $Script:NRAPIInstanceCapabilities[$cacheKey]
	}

	$version = $null
	$yaml = $null
	try {
		$version = (Invoke-WebRequest -Uri ("{0}/app-version.txt" -f $cacheKey) -UseBasicParsing -ErrorAction Stop).Content.Trim()
	} catch {
		$version = $null
	}

	try {
		$yaml = [System.Text.Encoding]::UTF8.GetString((Invoke-WebRequest -Uri ("{0}/apidocs-beta/NinjaRMM-API-v2.yaml" -f $cacheKey) -UseBasicParsing -ErrorAction Stop).Content)
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
