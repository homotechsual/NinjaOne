<#
	.SYNOPSIS
		Audits exported cmdlets against the repository OpenAPI snapshot.

	.DESCRIPTION
		Compares cmdlet metadata and public parameter contracts against the repository
		OpenAPI specification to identify contract drift such as missing operations and
		path placeholder mismatches. When the spec declares body properties, the audit
		also compares literal request-body assignments in cmdlets against those fields.
		A JSON and Markdown report are written to `.artifacts` for review in CI.
#>
[CmdletBinding()]
param(
	# Path to the repository OpenAPI snapshot.
	[string]$SpecPath = (Join-Path -Path $PSScriptRoot -ChildPath '..\..\ninjaOne-API-core-resources.yaml'),
	# Path to the public cmdlet source tree.
	[string]$CmdletRoot = (Join-Path -Path $PSScriptRoot -ChildPath '..\..\Source\Public'),
	# Output path for the JSON report.
	[string]$OutputPath = (Join-Path -Path $PSScriptRoot -ChildPath '..\..\.artifacts\cmdlet-spec-contract-issues.json')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Test-Path -Path $SpecPath -PathType Leaf)) {
	throw "Spec file not found: $SpecPath"
}

if (-not (Test-Path -Path $CmdletRoot -PathType Container)) {
	throw "Cmdlet root not found: $CmdletRoot"
}

$outputDirectory = Split-Path -Path $OutputPath -Parent
if (-not [string]::IsNullOrWhiteSpace($outputDirectory)) {
	$null = New-Item -Path $outputDirectory -ItemType Directory -Force
}

$yaml = Get-Content -Path $SpecPath -Raw
$lines = $yaml -split "`n"
$specOperations = @{}
$specBodyProperties = @{}

for ($i = 0; $i -lt $lines.Count; $i++) {
	if ($lines[$i] -match '^\s{2}(/v2/[^:]+):\s*$') {
		$path = $matches[1]
		for ($j = $i + 1; $j -lt $lines.Count; $j++) {
			if ($lines[$j] -match '^\s{2}/v2/') {
				break
			}

			if ($lines[$j] -match '^\s{4}(get|post|put|patch|delete):\s*$') {
				$method = $matches[1].ToUpperInvariant()
				$key = "$method $path"
				$pathParams = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
				$bodyProperties = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

				for ($k = $j + 1; $k -lt $lines.Count; $k++) {
					if ($lines[$k] -match '^\s{4}(get|post|put|patch|delete):\s*$' -or $lines[$k] -match '^\s{2}/v2/') {
						break
					}

					if ($lines[$k] -match '^\s{8}-\s+name:\s+([A-Za-z0-9_]+)\s*$') {
						$paramName = $matches[1]
						$isPathParam = $false

						for ($m = $k + 1; $m -lt $lines.Count; $m++) {
							if ($lines[$m] -match '^\s{8}-\s+name:\s+' -or $lines[$m] -match '^\s{4}(get|post|put|patch|delete):\s*$' -or $lines[$m] -match '^\s{2}/v2/') {
								break
							}

							if ($lines[$m] -match '^\s{10}in:\s+path\s*$') {
								$isPathParam = $true
								break
							}
						}

						if ($isPathParam) {
							[void]$pathParams.Add($paramName)
						}
					}

					if ($lines[$k] -match '^\s{6}requestBody:\s*$') {
						for ($n = $k + 1; $n -lt $lines.Count; $n++) {
							if ($lines[$n] -match '^\s{4}(get|post|put|patch|delete):\s*$' -or $lines[$n] -match '^\s{2}/v2/') {
								break
							}

							if ($lines[$n] -match '^\s{12}properties:\s*$') {
								for ($o = $n + 1; $o -lt $lines.Count; $o++) {
									if ($lines[$o] -match '^\s{10}(additionalProperties|type|description|required|properties):\s*' -or $lines[$o] -match '^\s{4}(get|post|put|patch|delete):\s*$' -or $lines[$o] -match '^\s{2}/v2/') {
										break
									}

									if ($lines[$o] -match '^\s{14}([A-Za-z0-9_]+):\s*$') {
										[void]$bodyProperties.Add($matches[1])
									}
								}
								break
							}
						}
					}
				}

				$specOperations[$key] = [string[]]$pathParams
				$specBodyProperties[$key] = [string[]]$bodyProperties
			}
		}
	}
}

$issues = [System.Collections.Generic.List[object]]::new()

Get-ChildItem -Path $CmdletRoot -Recurse -Filter '*.ps1' | ForEach-Object {
	$file = $_.FullName
	$content = Get-Content -Path $file -Raw
	if ([string]::IsNullOrWhiteSpace($content)) {
		return
	}

	$meta = [regex]::Match($content, "(?s)\[MetadataAttribute\(\s*'(?<path>/v2/[^']+)'\s*,\s*'(?<method>[^']+)'\s*\)\]")
	if (-not $meta.Success) {
		return
	}

	$path = $meta.Groups['path'].Value
	$method = $meta.Groups['method'].Value.ToUpperInvariant()
	$key = "$method $path"

	if (-not $specOperations.ContainsKey($key)) {
		$issues.Add([pscustomobject]@{
				Type = 'MissingSpecOperation'
				File = $file
				Operation = $key
				Details = 'Metadata operation not found in spec'
			})
		return
	}

	$paramBlock = [regex]::Match($content, '(?s)param\s*\((?<params>.*?)\)\s*process\s*\{')
	if (-not $paramBlock.Success) {
		return
	}

	$bodyAssignments = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
	foreach ($match in [regex]::Matches($content, '\$Body\.(?<name>[A-Za-z_][A-Za-z0-9_]*)\s*=')) {
		[void]$bodyAssignments.Add($match.Groups['name'].Value)
	}

	$declaredParams = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
	$paramText = $paramBlock.Groups['params'].Value

	foreach ($match in [regex]::Matches($paramText, '\$([A-Za-z_][A-Za-z0-9_]*)')) {
		[void]$declaredParams.Add($match.Groups[1].Value)
	}

	$currentAliases = @()
	foreach ($line in ($paramText -split "`n")) {
		if ($line -match '\[Alias\((?<values>[^\)]*)\)\]') {
			$currentAliases = @()
			foreach ($aliasMatch in [regex]::Matches($matches['values'], "'([^']+)'")) {
				$currentAliases += $aliasMatch.Groups[1].Value
			}
			continue
		}

		if ($line -match '\$([A-Za-z_][A-Za-z0-9_]*)') {
			if ($currentAliases.Count -gt 0) {
				foreach ($alias in $currentAliases) {
					[void]$declaredParams.Add($alias)
				}
				$currentAliases = @()
			}
		}
	}

	if ($bodyAssignments.Count -gt 0 -and $specBodyProperties.ContainsKey($key) -and $specBodyProperties[$key].Count -gt 0) {
		$expectedBodyProperties = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
		foreach ($expectedBodyProperty in $specBodyProperties[$key]) {
			[void]$expectedBodyProperties.Add($expectedBodyProperty)
		}

		foreach ($bodyAssignment in $bodyAssignments) {
			if (-not $expectedBodyProperties.Contains($bodyAssignment)) {
				$issues.Add([pscustomobject]@{
						Type = 'BodyParamMismatch'
						File = $file
						Operation = $key
						Details = "Request body key '$bodyAssignment' is not declared in the spec requestBody schema"
					})
			}
		}
	}

	$placeholders = @([regex]::Matches($path, '\{([^}]+)\}') | ForEach-Object { $_.Groups[1].Value })
	foreach ($placeholder in $placeholders) {
		if (-not $declaredParams.Contains($placeholder)) {
			$issues.Add([pscustomobject]@{
					Type = 'PathParamMismatch'
					File = $file
					Operation = $key
					Details = "Path placeholder {$placeholder} not exposed as cmdlet parameter"
				})
		}
	}
}

$issuesSorted = @($issues | Sort-Object Type, File, Operation)
$issuesSorted | ConvertTo-Json -Depth 5 | Set-Content -Path $OutputPath -Encoding UTF8

$markdownPath = [System.IO.Path]::ChangeExtension($OutputPath, '.md')
$summary = [System.Collections.Generic.List[string]]::new()
$summary.Add('# NinjaOne cmdlet/spec contract audit') | Out-Null
$summary.Add('') | Out-Null
$summary.Add(('| Issues | {0} |' -f $issuesSorted.Count)) | Out-Null
$summary.Add('') | Out-Null

if ($issuesSorted.Count -eq 0) {
	$summary.Add('No cmdlet/spec contract mismatches were detected.') | Out-Null
} else {
	$summary.Add('| Type | File | Operation | Details |') | Out-Null
	$summary.Add('| --- | --- | --- | --- |') | Out-Null
	foreach ($issue in $issuesSorted) {
		$summary.Add(('| {0} | {1} | {2} | {3} |' -f $issue.Type, $issue.File, $issue.Operation, $issue.Details)) | Out-Null
	}
}

$summaryLines = $summary.ToArray()
Set-Content -Path $markdownPath -Value $summaryLines -Encoding UTF8

if ($env:GITHUB_STEP_SUMMARY) {
	Add-Content -Path $env:GITHUB_STEP_SUMMARY -Value $summaryLines
}

Write-Host ('Issues: {0}' -f $issuesSorted.Count)
if ($issuesSorted.Count -gt 0) {
	$issuesSorted | Group-Object Type | Sort-Object Name | ForEach-Object {
		Write-Host ('{0}: {1}' -f $_.Name, $_.Count)
	}
}

if ($issuesSorted.Count -gt 0) {
	throw 'Cmdlet/spec contract mismatches were detected.'
}