#requires -Module PowerShellGet, @{ ModuleName = 'Pester'; ModuleVersion = '5.5.0'; MaximumVersion = '5.999' }
using namespace Microsoft.PackageManagement.Provider.Utility
using namespace System.Management.Automation
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSMissingParameterInlineComment', '', Justification = 'Internal test script does not require parameter descriptions.')]
param(
	[switch]$skipScriptAnalyzer,
	[switch]$includeVSCodeMarker,
	[switch]$useBuiltModule,
	[string[]]$Suite = @('core', 'private', 'public', 'docs'),
	[ValidateSet('Detailed', 'Normal', 'Minimal', 'None')]
	[string]$Verbosity = 'Detailed'
)
$repoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\\..')
Push-Location $repoRoot
$moduleName = (Get-Item -Path (Join-Path -Path $repoRoot -ChildPath 'Source\NinjaOne.psd1')).BaseName
# Disable default parameters during testing, just in case
$PSDefaultParameterValues += @{}
$PSDefaultParameterValues['Disabled'] = $true
$artifactsRoot = Join-Path -Path $repoRoot -ChildPath '.artifacts'
$null = New-Item -Path $artifactsRoot -ItemType Directory -Force
$artifactsPath = $artifactsRoot
Get-ChildItem -Path $artifactsPath -Filter 'TestResults.*.xml' -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
Get-ChildItem -Path $artifactsPath -Filter 'CodeCoverage.*.xml' -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
Get-ChildItem -Path $artifactsPath -Directory -Filter 'SourceModule-*' -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

function New-SourceModuleForTesting {
	<#
	.SYNOPSIS
		Creates a temporary source-based module for Pester coverage.
	.DESCRIPTION
		Builds a .psm1 that dot-sources all Source scripts and copies required binaries
		into an artifacts folder so coverage can map to source paths.
	.OUTPUTS
		[System.IO.FileInfo]
	#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSMissingParameterInlineComment', '', Justification = 'Internal test script does not require parameter descriptions.')]
	param(
		[Parameter(Mandatory = $true)]
		[string]$repoRoot,
		[Parameter(Mandatory = $true)]
		[string]$moduleName,
		[Parameter(Mandatory = $true)]
		[string]$artifactsPath
	)
	$sourceRoot = Join-Path -Path $repoRoot -ChildPath 'Source'
	$moduleRoot = Join-Path -Path $artifactsPath -ChildPath ('SourceModule-{0}' -f ([guid]::NewGuid().ToString('N')))
	$moduleManifest = Join-Path -Path $moduleRoot -ChildPath ('{0}.psd1' -f $moduleName)
	$moduleFile = Join-Path -Path $moduleRoot -ChildPath ('{0}.psm1' -f $moduleName)
	$moduleBinaries = Join-Path -Path $moduleRoot -ChildPath 'Binaries'

	$null = New-Item -Path $moduleRoot -ItemType Directory -Force
	Copy-Item -Path (Join-Path -Path $sourceRoot -ChildPath ('{0}.psd1' -f $moduleName)) -Destination $moduleManifest -Force
	Copy-Item -Path (Join-Path -Path $sourceRoot -ChildPath 'Binaries') -Destination $moduleBinaries -Recurse -Force

	$moduleLines = @()
	$moduleLines += ". '$((Join-Path -Path $sourceRoot -ChildPath 'Initialisation.ps1'))'"
	$moduleLines += Get-ChildItem -Path (Join-Path -Path $sourceRoot -ChildPath 'Classes') -Filter '*.ps1' |
	Sort-Object -Property Name |
	ForEach-Object { ". '$($_.FullName)'" }
	$moduleLines += Get-ChildItem -Path (Join-Path -Path $sourceRoot -ChildPath 'Private') -Filter '*.ps1' -Recurse |
	Sort-Object -Property FullName |
	ForEach-Object { ". '$($_.FullName)'" }
	$moduleLines += Get-ChildItem -Path (Join-Path -Path $sourceRoot -ChildPath 'Public') -Filter '*.ps1' -Recurse |
	Sort-Object -Property FullName |
	ForEach-Object { ". '$($_.FullName)'" }

	Set-Content -Path $moduleFile -Value $moduleLines -Encoding Ascii
	return Get-Item -Path $moduleManifest
}

if ($useBuiltModule) {
	$ModulePath = Resolve-Path -Path '.\Output\*\*' | Sort-Object -Property BaseName | Select-Object -Last 1 -ExpandProperty Path
	$FoundModule = Get-ChildItem -Path ('{0}\*' -f $ModulePath) -Filter ('{0}.psd1' -f $moduleName) -ErrorAction SilentlyContinue
	if (!$FoundModule) {
		throw ('Cannot find {0}.psd1 in {1}' -f $moduleName, $ModulePath)
	}
} else {
	$FoundModule = New-SourceModuleForTesting -repoRoot $repoRoot -moduleName $moduleName -artifactsPath $artifactsPath
}
Remove-Module $moduleName -ErrorAction Ignore -Force
$ModuleUnderTest = Import-Module $FoundModule.FullName -PassThru -Force -DisableNameChecking -Verbose:$false
$env:NINJAONE_MODULE_MANIFEST = $FoundModule.FullName
$env:NINJAONE_MODULE_NAME = $moduleName
Write-Verbose ('Invoke-Pester for Module {0} version {1}' -f $ModuleUnderTest, $ModuleUnderTest.Version)
$PesterConfiguration = New-PesterConfiguration

if ($useBuiltModule) {
	# Measure coverage against the built module file that is actually executed.
	$coverageFiles = @(Get-ChildItem -Path $ModuleUnderTest.ModuleBase -Filter ('{0}.psm1' -f $moduleName) -File |
		Select-Object -ExpandProperty FullName)
} else {
	# Measure coverage against the source files for granular component reporting.
	$coverageRoot = Join-Path -Path $repoRoot -ChildPath 'Source'
	$coverageFiles = @(Get-ChildItem -Path $coverageRoot -Recurse -Include '*.ps1' -Exclude 'Initialisation.ps1' |
		Where-Object { $_.FullName -notmatch 'TestScaffold|\\Tests\\' } |
		Select-Object -ExpandProperty FullName)
}

Write-Verbose "Code coverage will measure $($coverageFiles.Count) files:"
$coverageFiles | ForEach-Object { Write-Verbose "  - $_" }

$testSuites = @(
	[pscustomobject]@{
		Name = 'core'
		Paths = @('.\Tests\NinjaOne.Core.Tests.ps1', '.\Tests\NinjaOne.Schema.Tests.ps1', '.\Tests\NinjaOne.InstanceCapabilities.Tests.ps1')
	},
	[pscustomobject]@{
		Name = 'private'
		Paths = @('.\Tests\NinjaOne.Private.Tests.ps1')
	},
	[pscustomobject]@{
		Name = 'public'
		Paths = @('.\Tests\NinjaOne.Public.Tests.ps1')
	},
	[pscustomobject]@{
		Name = 'docs'
		Paths = @('.\Tests\NinjaOne.Help.Tests.ps1')
	}
)

if ($includeVSCodeMarker -and -not $PSBoundParameters.ContainsKey('Verbosity')) {
	$Verbosity = 'Normal'
}

$validSuites = $testSuites.Name | Sort-Object -Unique
$requestedSuites = @(
	$Suite |
	ForEach-Object { $_ -split '\s*,\s*' } |
	Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
	Select-Object -Unique
)
$invalidSuites = $requestedSuites | Where-Object { $_ -notin $validSuites }
if ($invalidSuites) {
	throw ('Invalid suite selection: {0}. Valid values: {1}' -f (($invalidSuites | Sort-Object) -join ', '), ($validSuites -join ', '))
}

$selectedSuites = $testSuites | Where-Object { $_.Name -in $requestedSuites }
if (-not $selectedSuites) {
	throw ('No matching test suites were selected. Valid values: {0}' -f ($validSuites -join ', '))
}

foreach ($testSuite in $selectedSuites) {
	$PesterConfiguration = New-PesterConfiguration
	$PesterConfiguration.CodeCoverage.Enabled = $true
	$PesterConfiguration.CodeCoverage.OutputPath = Join-Path -Path $artifactsPath -ChildPath ('CodeCoverage.{0}.xml' -f $testSuite.Name)
	$PesterConfiguration.CodeCoverage.Path = $coverageFiles
	$PesterConfiguration.Output.Verbosity = $Verbosity
	$PesterConfiguration.Run.Path = $testSuite.Paths
	$PesterConfiguration.Run.PassThru = $true
	$PesterConfiguration.TestResult.Enabled = $true
	$PesterConfiguration.TestResult.OutputPath = Join-Path -Path $artifactsPath -ChildPath ('TestResults.{0}.xml' -f $testSuite.Name)
	$PesterConfiguration.TestResult.OutputFormat = 'JUnitXml'
	if ($includeVSCodeMarker) {
		if ($PesterConfiguration | Get-Member -Name 'VSCodeMarker' -ErrorAction SilentlyContinue) {
			$PesterConfiguration.VSCodeMarker = $true
		}
	}

	Write-Host ("`n=== Running {0} test suite ===" -f $testSuite.Name) -ForegroundColor Cyan
	$null = Invoke-Pester -Configuration $PesterConfiguration
}

Write-Host "`n=== Test Results Summary ===" -ForegroundColor Cyan

$allResults = @()
$totalPassed = 0
$totalFailed = 0
$totalSkipped = 0
$allFailures = @()

if (Test-Path $artifactsPath) {
	$testResultsFiles = Get-ChildItem -Path $artifactsPath -Filter 'TestResults.*.xml' -ErrorAction SilentlyContinue
	
	foreach ($testResultsFile in $testResultsFiles) {
		$xmlContent = [xml](Get-Content -Path $testResultsFile.FullName -Raw)
		$testsuites = $xmlContent.DocumentElement
		
		$suitePassed = [int]$testsuites.tests - [int]$testsuites.failures - [int]$testsuites.skipped
		$suiteFailed = [int]$testsuites.failures
		$suiteSkipped = [int]$testsuites.skipped
		
		$totalPassed += $suitePassed
		$totalFailed += $suiteFailed
		$totalSkipped += $suiteSkipped
		
		Write-Host ("{0}: {1} passed, {2} failed, {3} skipped" -f $testResultsFile.BaseName, $suitePassed, $suiteFailed, $suiteSkipped) -ForegroundColor $(if ($suiteFailed -gt 0) { 'Red' } else { 'Green' })
		
		# Extract all failures
		$failures = $testsuites.SelectNodes('//testcase[@status="Failed"]')
		foreach ($failure in $failures) {
			$failureMsg = $failure.SelectSingleNode('failure')
			$allFailures += [pscustomobject]@{
				SuiteFile = $testResultsFile.BaseName
				TestName = $failure.name
				ClassName = $failure.classname
				Message = $failureMsg.message
				Time = $failure.time
			}
		}
		
		$allResults += [pscustomobject]@{
			Suite = $testResultsFile.BaseName
			Passed = $suitePassed
			Failed = $suiteFailed
			Skipped = $suiteSkipped
			Total = [int]$testsuites.tests
			FilePath = $testResultsFile.FullName
		}
	}
}

if ($totalFailed -gt 0) {
	Write-Host "`nTotal: $totalPassed passed, $totalFailed failed, $totalSkipped skipped" -ForegroundColor Red -BackgroundColor DarkRed
} else {
	Write-Host "`nTotal: $totalPassed passed, $totalFailed failed, $totalSkipped skipped" -ForegroundColor Green
}

if ($allFailures.Count -gt 0) {
	Write-Host "`n!!! Failed Tests !!!" -ForegroundColor Red
	$allFailures | Format-Table -AutoSize
}

Write-Host "===========================`n" -ForegroundColor Cyan

# Return combined results object
$combinedResults = [pscustomobject]@{
	TotalPassed = $totalPassed
	TotalFailed = $totalFailed
	TotalSkipped = $totalSkipped
	Suites = $allResults
	Failures = $allFailures
	AllResults = $xmlContent
	ExecutedAt = Get-Date
}

$combinedResults

if (-not $skipScriptAnalyzer) {
	Write-Host "`n=== Running PSScriptAnalyzer ===" -ForegroundColor Cyan
		$scriptAnalyzerScript = Join-Path -Path $repoRoot -ChildPath 'DevOps\Quality\run-pssa.ps1'
		& $scriptAnalyzerScript
}
Pop-Location

# Re-enable default parameters after testing
$PSDefaultParameterValues['Disabled'] = $false
