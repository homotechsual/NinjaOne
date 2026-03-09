function Get-NinjaOneOpenApiPaths {
	<#
	.SYNOPSIS
	Parses an OpenAPI YAML document to extract paths and methods.
	.DESCRIPTION
	Extracts the OpenAPI paths and HTTP methods from a YAML document without requiring a YAML parser module.
	.OUTPUTS
	[Hashtable]
	#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSMissingParameterInlineComment', '', Justification = 'Internal private function does not require parameter descriptions.')]
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[String]$OpenApiYaml
	)

	$paths = @{}
	$allowedMethods = @('GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS', 'HEAD')
	$inPaths = $false
	$currentPath = $null
	$lines = $OpenApiYaml -split "`n"

	foreach ($line in $lines) {
		$lineToParse = $line.TrimEnd("`r")
		if (-not $inPaths) {
			if ($lineToParse -match '^\s*paths:\s*$') {
				$inPaths = $true
			}
			continue
		}

		if ($lineToParse -match '^\S' -and $lineToParse -notmatch '^\s*paths:\s*$') {
			break
		}

		if ($lineToParse -match '^\s{2,}(/[^:]+):\s*$') {
			$currentPath = $Matches[1]
			if (-not $paths.ContainsKey($currentPath)) {
				$paths[$currentPath] = [System.Collections.Generic.HashSet[string]]::new()
			}
			continue
		}

		if ($currentPath -and $lineToParse -match '^\s{4,}([A-Za-z]+)\s*:\s*$') {
			$method = $Matches[1].ToUpperInvariant()
			if ($allowedMethods -contains $method) {
				$paths[$currentPath].Add($method) | Out-Null
			}
		}
	}

	return $paths
}
