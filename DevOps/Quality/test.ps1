#requires -Module PowerShellGet, @{ ModuleName = 'Pester'; ModuleVersion = '5.5.0'; MaximumVersion = '5.999' }
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSMissingParameterInlineComment', '', Justification = 'Internal test script does not require parameter descriptions.')]
using namespace Microsoft.PackageManagement.Provider.Utility
using namespace System.Management.Automation
param(
	[switch]$SkipScriptAnalyzer,
	[switch]$IncludeVSCodeMarker,
	[switch]$UseBuiltModule
)
$RepoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\\..')
Push-Location $RepoRoot
$ModuleName = (Get-Item -Path (Join-Path -Path $RepoRoot -ChildPath 'Source\NinjaOne.psd1')).BaseName
# Disable default parameters during testing, just in case
$PSDefaultParameterValues += @{}
$PSDefaultParameterValues['Disabled'] = $true
$artifactsPath = Join-Path -Path $RepoRoot -ChildPath '.artifacts'
$null = New-Item -Path $artifactsPath -ItemType Directory -Force

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
		[string]$RepoRoot,
		[Parameter(Mandatory = $true)]
		[string]$ModuleName,
		[Parameter(Mandatory = $true)]
		[string]$ArtifactsPath
	)
	$sourceRoot = Join-Path -Path $RepoRoot -ChildPath 'Source'
	$moduleRoot = Join-Path -Path $ArtifactsPath -ChildPath 'SourceModule'
	$moduleManifest = Join-Path -Path $moduleRoot -ChildPath ('{0}.psd1' -f $ModuleName)
	$moduleFile = Join-Path -Path $moduleRoot -ChildPath ('{0}.psm1' -f $ModuleName)
	$moduleBinaries = Join-Path -Path $moduleRoot -ChildPath 'Binaries'

	$null = New-Item -Path $moduleRoot -ItemType Directory -Force
	Copy-Item -Path (Join-Path -Path $sourceRoot -ChildPath ('{0}.psd1' -f $ModuleName)) -Destination $moduleManifest -Force
	if (Test-Path -Path $moduleBinaries) {
		Remove-Item -Path $moduleBinaries -Recurse -Force
	}
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

if ($UseBuiltModule) {
	$ModulePath = Resolve-Path -Path '.\Output\*\*' | Sort-Object -Property BaseName | Select-Object -Last 1 -ExpandProperty Path
	$FoundModule = Get-ChildItem -Path ('{0}\*' -f $ModulePath) -Filter ('{0}.psd1' -f $ModuleName) -ErrorAction SilentlyContinue
	if (!$FoundModule) {
		throw ('Cannot find {0}.psd1 in {1}' -f $ModuleName, $ModulePath)
	}
} else {
	$FoundModule = New-SourceModuleForTesting -RepoRoot $RepoRoot -ModuleName $ModuleName -ArtifactsPath $artifactsPath
}
Remove-Module $ModuleName -ErrorAction Ignore -Force
$ModuleUnderTest = Import-Module $FoundModule.FullName -PassThru -Force -DisableNameChecking -Verbose:$false
$env:NINJAONE_MODULE_MANIFEST = $FoundModule.FullName
$env:NINJAONE_MODULE_NAME = $ModuleName
Write-Verbose ('Invoke-Pester for Module {0} version {1}' -f $ModuleUnderTest, $ModuleUnderTest.Version)
$PesterConfiguration = New-PesterConfiguration

if ($UseBuiltModule) {
	# Measure coverage against the built module file that is actually executed.
	$coverageFiles = @(Get-ChildItem -Path $ModuleUnderTest.ModuleBase -Filter ('{0}.psm1' -f $ModuleName) -File |
		Select-Object -ExpandProperty FullName)
} else {
	# Measure coverage against the source files for granular component reporting.
	$coverageRoot = Join-Path -Path $RepoRoot -ChildPath 'Source'
	$coverageFiles = @(Get-ChildItem -Path $coverageRoot -Recurse -Include '*.ps1' -Exclude 'Initialisation.ps1' |
		Where-Object { $_.FullName -notmatch 'TestScaffold|\\Tests\\' } |
		Select-Object -ExpandProperty FullName)
}

Write-Verbose "Code coverage will measure $($coverageFiles.Count) files:"
$coverageFiles | ForEach-Object { Write-Verbose "  - $_" }

$testSuites = @(
	@{
		Name  = 'core'
			Paths = @('.\Tests\NinjaOne.Core.Tests.ps1', '.\Tests\NinjaOne.Schema.Tests.ps1', '.\Tests\NinjaOne.InstanceCapabilities.Tests.ps1')
	},
	@{
		Name  = 'private'
		Paths = @('.\Tests\NinjaOne.Private.Tests.ps1')
	},
	@{
		Name  = 'public'
		Paths = @('.\Tests\NinjaOne.Public.Tests.ps1')
	},
	@{
		Name  = 'docs'
		Paths = @('.\Tests\NinjaOne.Help.Tests.ps1')
	}
)

foreach ($suite in $testSuites) {
	$PesterConfiguration = New-PesterConfiguration
	$PesterConfiguration.CodeCoverage.Enabled = $true
	$PesterConfiguration.CodeCoverage.OutputPath = Join-Path -Path $artifactsPath -ChildPath ("CodeCoverage.{0}.xml" -f $suite.Name)
	$PesterConfiguration.CodeCoverage.Path = $coverageFiles
	$PesterConfiguration.Output.Verbosity = 'Detailed'
	$PesterConfiguration.Run.Path = $suite.Paths
	$PesterConfiguration.Run.PassThru = $true
	$PesterConfiguration.TestResult.Enabled = $true
	$PesterConfiguration.TestResult.OutputPath = Join-Path -Path $artifactsPath -ChildPath ("TestResults.{0}.xml" -f $suite.Name)
	$PesterConfiguration.TestResult.OutputFormat = 'JUnitXml'
	if ($IncludeVSCodeMarker) {
		if ($PesterConfiguration | Get-Member -Name 'VSCodeMarker' -ErrorAction SilentlyContinue) {
			$PesterConfiguration.VSCodeMarker = $true
		}
	}

	Write-Host ("`n=== Running {0} test suite ===" -f $suite.Name) -ForegroundColor Cyan
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

if (-not $SkipScriptAnalyzer) {
	Write-Host "`n=== Running PSScriptAnalyzer ===" -ForegroundColor Cyan
	$null = Invoke-ScriptAnalyzer $ModuleUnderTest.Path -Settings (Join-Path -Path $RepoRoot -ChildPath 'PSScriptAnalyzerSettings.psd1')
}
Pop-Location

# Re-enable default parameters after testing
$PSDefaultParameterValues['Disabled'] = $false
