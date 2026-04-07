<#
	.SYNOPSIS
		Checks NinjaOne instances for endpoint drift against the repository OpenAPI snapshot.

	.DESCRIPTION
		Imports the built NinjaOne module, downloads the live OpenAPI capability data for each
		configured instance, and compares those endpoints against `ninjaOne-API-core-resources.yaml`.
		A JSON and Markdown report are written to `.artifacts` for review in CI.
#>
[CmdletBinding()]
param(
	# Instance short names to query.
	[String[]]$Instances = @('eu', 'oc', 'us', 'ca', 'us2', 'fed'),
	# Path to the built module manifest. Defaults to the latest manifest under Output.
	[String]$ManifestPath,
	# Path to the repository OpenAPI snapshot.
	[String]$SpecPath,
	# Output path for the JSON report.
	[String]$OutputPath,
	# Fail the script when live coverage gaps or endpoint removals are detected.
	[Alias('FailOnNewEndpoints')]
	[Switch]$FailOnDetectedDrift
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$RepoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..')
if (-not $SpecPath) {
	$SpecPath = Join-Path -Path $RepoRoot -ChildPath 'ninjaOne-API-core-resources.yaml'
}
if (-not $OutputPath) {
	$OutputPath = Join-Path -Path $RepoRoot -ChildPath '.artifacts\instance-capability-report.json'
}
if (-not $ManifestPath) {
	$outputManifestDirectory = Join-Path -Path $RepoRoot -ChildPath 'Output\NinjaOne'
	if (-not (Test-Path -Path $outputManifestDirectory -PathType Container)) {
		throw 'No built NinjaOne manifest found under Output\NinjaOne. Build the module first.'
	}

	$manifestMatches = @(
		Get-ChildItem -Path (Join-Path -Path $outputManifestDirectory -ChildPath '*\NinjaOne.psd1') -File -ErrorAction SilentlyContinue
	)
	if (-not $manifestMatches) {
		throw 'No built NinjaOne manifest found under Output\NinjaOne. Build the module first.'
	}

	$ManifestPath = (
		$manifestMatches |
		Sort-Object -Property @(
			@{
				Expression = {
					$manifestVersion = [version]'0.0'
					if (-not [version]::TryParse($_.Directory.Name, [ref]$manifestVersion)) {
						$manifestVersion = [version]'0.0'
					}
					$manifestVersion
				}
			},
			'FullName'
		) |
		Select-Object -Last 1 -ExpandProperty FullName
	)
}

$outputDirectory = Split-Path -Path $OutputPath -Parent
if ([string]::IsNullOrWhiteSpace($outputDirectory)) {
	$outputDirectory = '.'
}
$null = New-Item -Path $outputDirectory -ItemType Directory -Force

$module = Import-Module -Name $ManifestPath -Force -DisableNameChecking -PassThru -ErrorAction Stop

$endpointSetBuilder = {
	param(
		# OpenAPI paths keyed by route.
		[Parameter(Mandatory)]
		[Hashtable]$Paths
	)

	$endpointSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
	foreach ($path in ($Paths.Keys | Sort-Object)) {
		$methods = @($Paths[$path])
		if ($methods.Count -eq 0) {
			$null = $endpointSet.Add(('ANY {0}' -f $path))
			continue
		}

		foreach ($method in ($methods | Sort-Object)) {
			$null = $endpointSet.Add(('{0} {1}' -f $method.ToUpperInvariant(), $path))
		}
	}

	return @($endpointSet)
}

$cmdletEndpointCollector = {
	param(
		# Imported NinjaOne module object to inspect.
		[Parameter(Mandatory)]
		$Module
	)

	$endpointSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
	$exportedFunctionNames = @($Module.ExportedFunctions.Keys)
	$commands = @(Get-Command -Module $Module.Name -CommandType Function | Where-Object { $_.Name -in $exportedFunctionNames })

	foreach ($command in $commands) {
		$attributes = @($command.ScriptBlock.Attributes | Where-Object { $_ -is [MetadataAttribute] })
		if (-not $attributes -or $attributes.Count -eq 0) {
			continue
		}

		$tags = @()
		foreach ($attribute in $attributes) {
			$tags += $attribute.GetTags()
		}

		if ($tags -contains 'IGNORE') {
			continue
		}

		for ($i = 0; $i -lt $tags.Count; $i += 2) {
			$path = $tags[$i]
			if ([string]::IsNullOrWhiteSpace($path)) {
				continue
			}
			if (-not $path.StartsWith('/')) {
				$path = '/' + $path
			}

			$method = 'ANY'
			if ($i + 1 -lt $tags.Count -and -not [string]::IsNullOrWhiteSpace($tags[$i + 1])) {
				$method = $tags[$i + 1].ToUpperInvariant()
			}

			$null = $endpointSet.Add(('{0} {1}' -f $method, $path))
		}
	}

	return @($endpointSet)
}

$localYaml = Get-Content -Path $SpecPath -Raw
$repoPaths = & $module {
	param($OpenApiYaml)
	Get-NinjaOneOpenApiPaths -OpenApiYaml $OpenApiYaml
} $localYaml
$repoEndpointSet = & $endpointSetBuilder -Paths $repoPaths
$cmdletEndpointSet = & $cmdletEndpointCollector -Module $module

$results = foreach ($instance in ($Instances | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique)) {
	Write-Host ('Checking instance {0}...' -f $instance) -ForegroundColor Cyan
	$capability = Get-NinjaOneInstanceCapabilities -Instance $instance -IncludePaths -Refresh
	$instanceEndpointSet = & $endpointSetBuilder -Paths $capability.Paths

	$liveWithoutCmdletCoverage = @($instanceEndpointSet | Where-Object { $_ -notin $cmdletEndpointSet } | Sort-Object)
	$repoMissingFromLive = @($repoEndpointSet | Where-Object { $_ -notin $instanceEndpointSet } | Sort-Object)
	$cmdletMissingFromLive = @($cmdletEndpointSet | Where-Object { $_ -notin $instanceEndpointSet } | Sort-Object)
	$removedRepoAndCmdlet = @($repoMissingFromLive | Where-Object { $_ -in $cmdletEndpointSet } | Sort-Object)
	$removedRepoOnly = @($repoMissingFromLive | Where-Object { $_ -notin $cmdletEndpointSet } | Sort-Object)
	$removedCmdletOnly = @($cmdletMissingFromLive | Where-Object { $_ -notin $repoEndpointSet } | Sort-Object)

	[PSCustomObject]@{
		Instance = $instance
		BaseUrl = $capability.BaseUrl
		AppVersion = $capability.AppVersion
		PathCount = $capability.PathCount
		LiveEndpointWithoutCmdletCoverageCount = $liveWithoutCmdletCoverage.Count
		LiveEndpointsWithoutCmdletCoverage = $liveWithoutCmdletCoverage
		RemovedRepoAndCmdletCount = $removedRepoAndCmdlet.Count
		RemovedRepoAndCmdletEndpoints = $removedRepoAndCmdlet
		RemovedRepoOnlyCount = $removedRepoOnly.Count
		RemovedRepoOnlyEndpoints = $removedRepoOnly
		RemovedCmdletOnlyCount = $removedCmdletOnly.Count
		RemovedCmdletOnlyEndpoints = $removedCmdletOnly
	}
}

$results | ConvertTo-Json -Depth 8 | Set-Content -Path $OutputPath -Encoding UTF8
$markdownPath = [System.IO.Path]::ChangeExtension($OutputPath, '.md')

$summary = [System.Collections.Generic.List[string]]::new()
$summary.Add('# NinjaOne instance endpoint drift report') | Out-Null
$summary.Add('') | Out-Null
$summary.Add('| Instance | App version | Paths | Live endpoints without cmdlet coverage | Removed (repo + cmdlet) | Removed (repo only) | Removed (cmdlet only) |') | Out-Null
$summary.Add('| --- | --- | ---: | ---: | ---: | ---: | ---: |') | Out-Null

foreach ($result in $results) {
	$summary.Add(('| {0} | {1} | {2} | {3} | {4} | {5} | {6} |' -f $result.Instance, $result.AppVersion, $result.PathCount, $result.LiveEndpointWithoutCmdletCoverageCount, $result.RemovedRepoAndCmdletCount, $result.RemovedRepoOnlyCount, $result.RemovedCmdletOnlyCount)) | Out-Null
}

$coverageResults = @($results | Where-Object { $_.LiveEndpointWithoutCmdletCoverageCount -gt 0 })
if ($coverageResults.Count -gt 0) {
	$summary.Add('') | Out-Null
	$summary.Add('## Live endpoints without matching cmdlet coverage') | Out-Null
	foreach ($result in $coverageResults) {
		$summary.Add('') | Out-Null
		$summary.Add(('### {0} ({1})' -f $result.Instance, $result.BaseUrl)) | Out-Null
		foreach ($endpoint in $result.LiveEndpointsWithoutCmdletCoverage) {
			$summary.Add(('- `{0}`' -f $endpoint)) | Out-Null
		}
	}
} else {
	$summary.Add('') | Out-Null
	$summary.Add('No live endpoints without cmdlet coverage were detected.') | Out-Null
}

$removalResults = @($results | Where-Object { $_.RemovedRepoAndCmdletCount -gt 0 -or $_.RemovedRepoOnlyCount -gt 0 -or $_.RemovedCmdletOnlyCount -gt 0 })
if ($removalResults.Count -gt 0) {
	$summary.Add('') | Out-Null
	$summary.Add('## Endpoints removed from live instances') | Out-Null
	foreach ($result in $removalResults) {
		$summary.Add('') | Out-Null
		$summary.Add(('### {0} ({1})' -f $result.Instance, $result.BaseUrl)) | Out-Null
		if ($result.RemovedRepoAndCmdletCount -gt 0) {
			$summary.Add('- Removed from live and still referenced by both repo spec and cmdlets:') | Out-Null
			foreach ($endpoint in $result.RemovedRepoAndCmdletEndpoints) {
				$summary.Add(('  - `{0}`' -f $endpoint)) | Out-Null
			}
		}
		if ($result.RemovedRepoOnlyCount -gt 0) {
			$summary.Add('- Removed from live and still referenced by the repo spec only:') | Out-Null
			foreach ($endpoint in $result.RemovedRepoOnlyEndpoints) {
				$summary.Add(('  - `{0}`' -f $endpoint)) | Out-Null
			}
		}
		if ($result.RemovedCmdletOnlyCount -gt 0) {
			$summary.Add('- Removed from live and still referenced by cmdlets only:') | Out-Null
			foreach ($endpoint in $result.RemovedCmdletOnlyEndpoints) {
				$summary.Add(('  - `{0}`' -f $endpoint)) | Out-Null
			}
		}
	}
} else {
	$summary.Add('') | Out-Null
	$summary.Add('No removed endpoints were detected across the tracked comparison sets.') | Out-Null
}

$summaryLines = $summary.ToArray()
Set-Content -Path $markdownPath -Value $summaryLines -Encoding UTF8
if ($env:GITHUB_STEP_SUMMARY) {
	Add-Content -Path $env:GITHUB_STEP_SUMMARY -Value $summaryLines
}

$totalDriftMeasure = $results | Measure-Object -Property LiveEndpointWithoutCmdletCoverageCount -Sum
$totalCoverageGaps = if ($null -ne $totalDriftMeasure.Sum) {
	[int]$totalDriftMeasure.Sum
} else {
	0
}
$totalRemovedRepoAndCmdlet = (($results | Measure-Object -Property RemovedRepoAndCmdletCount -Sum).Sum | ForEach-Object { if ($null -ne $_) { [int]$_ } else { 0 } })
$totalRemovedRepoOnly = (($results | Measure-Object -Property RemovedRepoOnlyCount -Sum).Sum | ForEach-Object { if ($null -ne $_) { [int]$_ } else { 0 } })
$totalRemovedCmdletOnly = (($results | Measure-Object -Property RemovedCmdletOnlyCount -Sum).Sum | ForEach-Object { if ($null -ne $_) { [int]$_ } else { 0 } })
$totalDriftIssues = $totalCoverageGaps + $totalRemovedRepoAndCmdlet + $totalRemovedRepoOnly + $totalRemovedCmdletOnly
$driftDetected = $totalDriftIssues -gt 0

if ($env:GITHUB_OUTPUT) {
	Add-Content -Path $env:GITHUB_OUTPUT -Value ("drift_detected={0}" -f $driftDetected.ToString().ToLowerInvariant())
	Add-Content -Path $env:GITHUB_OUTPUT -Value ("drift_issue_count={0}" -f $totalDriftIssues)
}

if ($FailOnDetectedDrift -and $driftDetected) {
	throw ('Detected {0} live endpoint coverage/removal issue(s) across the monitored NinjaOne instances.' -f $totalDriftIssues)
}

Write-Host ('✓ Instance capability check completed. Report written to {0}' -f $OutputPath) -ForegroundColor Green
