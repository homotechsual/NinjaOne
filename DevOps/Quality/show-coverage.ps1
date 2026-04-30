[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSMissingParameterInlineComment', '', Justification = 'Internal dev script does not require parameter descriptions.')]
param(
	[string[]]$Suite = @('private', 'public'),
	[ValidateSet('Summary', 'Full')]
	[string]$Detail = 'Summary',
	# Show files below this line-coverage threshold (0-100). Defaults to 50.
	[int]$Threshold = 50
)

$repoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\\..')
$artifactsPath = Join-Path -Path $repoRoot -ChildPath '.artifacts'

if (-not (Test-Path $artifactsPath)) {
	throw 'No .artifacts directory found. Run the test suite first (test.ps1).'
}

foreach ($suite in $Suite) {
	$xmlPath = Join-Path -Path $artifactsPath -ChildPath ('CodeCoverage.{0}.xml' -f $suite)
	if (-not (Test-Path $xmlPath)) {
		Write-Warning ('No coverage file found for suite "{0}". Run: test.ps1 -Suite {0}' -f $suite)
		continue
	}

	[xml]$xml = Get-Content -Path $xmlPath -Raw

	# Aggregate totals from all package/class counters at the report level
	$reportCounters = $xml.report.counter
	$instrCovered = [int]($reportCounters | Where-Object { $_.type -eq 'INSTRUCTION' } | Select-Object -ExpandProperty covered)
	$instrMissed = [int]($reportCounters | Where-Object { $_.type -eq 'INSTRUCTION' } | Select-Object -ExpandProperty missed)
	$lineCovered = [int]($reportCounters | Where-Object { $_.type -eq 'LINE' } | Select-Object -ExpandProperty covered)
	$lineMissed = [int]($reportCounters | Where-Object { $_.type -eq 'LINE' } | Select-Object -ExpandProperty missed)
	$methodCovered = [int]($reportCounters | Where-Object { $_.type -eq 'METHOD' } | Select-Object -ExpandProperty covered)
	$methodMissed = [int]($reportCounters | Where-Object { $_.type -eq 'METHOD' } | Select-Object -ExpandProperty missed)

	$instrTotal = $instrCovered + $instrMissed
	$lineTotal = $lineCovered + $lineMissed
	$methodTotal = $methodCovered + $methodMissed

	$instrPct = if ($instrTotal -gt 0) { [math]::Round($instrCovered / $instrTotal * 100, 2) } else { 0 }
	$linePct = if ($lineTotal -gt 0) { [math]::Round($lineCovered / $lineTotal * 100, 2) } else { 0 }
	$methodPct = if ($methodTotal -gt 0) { [math]::Round($methodCovered / $methodTotal * 100, 2) } else { 0 }

	$suiteColor = if ($linePct -ge 75) { 'Green' } elseif ($linePct -ge 40) { 'Yellow' } else { 'Red' }

	Write-Host ("`n=== Coverage: {0} suite ===" -f $suite.ToUpper()) -ForegroundColor Cyan
	Write-Host ('  Instructions : {0,6}/{1,-6} ({2}%)' -f $instrCovered, $instrTotal, $instrPct) -ForegroundColor $suiteColor
	Write-Host ('  Lines        : {0,6}/{1,-6} ({2}%)' -f $lineCovered, $lineTotal, $linePct) -ForegroundColor $suiteColor
	Write-Host ('  Methods      : {0,6}/{1,-6} ({2}%)' -f $methodCovered, $methodTotal, $methodPct) -ForegroundColor $suiteColor

	if ($Detail -eq 'Full') {
		# Per-file breakdown — collect all <class> elements across all packages
		$classes = $xml.report.package | ForEach-Object { $_.class }

		$fileRows = foreach ($class in $classes) {
			$cLineCov = [int]($class.counter | Where-Object { $_.type -eq 'LINE' } | Select-Object -ExpandProperty covered)
			$cLineMiss = [int]($class.counter | Where-Object { $_.type -eq 'LINE' } | Select-Object -ExpandProperty missed)
			$cTotal = $cLineCov + $cLineMiss
			$pct = if ($cTotal -gt 0) { [math]::Round($cLineCov / $cTotal * 100, 1) } else { 0 }
			[pscustomobject]@{
				File = $class.name -replace '^Source/', ''
				Covered = $cLineCov
				Total = $cTotal
				'%' = $pct
			}
		}

		$below = $fileRows | Where-Object { $_.'%' -lt $Threshold } | Sort-Object '%'
		if ($below) {
			Write-Host ("`n  Files below {0}% line coverage ({1} files):" -f $Threshold, $below.Count) -ForegroundColor Yellow
			$below | Format-Table -AutoSize | Out-String | Write-Host
		} else {
			Write-Host ("`n  All files are at or above {0}% line coverage." -f $Threshold) -ForegroundColor Green
		}
	}
}

Write-Host ''
