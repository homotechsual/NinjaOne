#requires -Module PowerShellGet, @{ ModuleName = 'Pester'; ModuleVersion = '5.5.0'; MaximumVersion = '5.999' }
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
		Paths = @('.\Tests\NinjaOne.Core.Tests.ps1', '.\Tests\NinjaOne.Schema.Tests.ps1')
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
		$PesterConfiguration.VSCodeMarker = $true
	}

	Write-Host ("`n=== Running {0} test suite ===" -f $suite.Name) -ForegroundColor Cyan
	Invoke-Pester -Configuration $PesterConfiguration
}

Write-Host "`n=== Test Artifacts ===" -ForegroundColor Cyan
if (Test-Path $artifactsPath) {
	Get-ChildItem -Path $artifactsPath -Recurse | Format-Table FullName, Length, LastWriteTime
	
	# Show XML file sizes and first few lines
	$coverageFiles = Get-ChildItem -Path $artifactsPath -Filter 'CodeCoverage.*.xml' -ErrorAction SilentlyContinue
	$testResultsFiles = Get-ChildItem -Path $artifactsPath -Filter 'TestResults.*.xml' -ErrorAction SilentlyContinue
	
	foreach ($coverageFile in $coverageFiles) {
		Write-Host ("{0}:" -f $coverageFile.Name) -ForegroundColor Green
		$xmlContent = [xml](Get-Content -Path $coverageFile.FullName -Raw)
		Write-Host "  Root element: $($xmlContent.DocumentElement.Name)"
		Write-Host "  File count: $(($xmlContent.DocumentElement.SelectNodes('//File')).Count)"
	}
	
	foreach ($testResultsFile in $testResultsFiles) {
		Write-Host ("{0}:" -f $testResultsFile.Name) -ForegroundColor Green
		$xmlContent = [xml](Get-Content -Path $testResultsFile.FullName -Raw)
		Write-Host "  Root element: $($xmlContent.DocumentElement.Name)"
		Write-Host "  Test suites: $(($xmlContent.DocumentElement.SelectNodes('//testcase')).Count)"
	}
} else {
	Write-Host 'No artifacts directory found!' -ForegroundColor Red
}
Write-Host "====================`n" -ForegroundColor Cyan

if (-not $SkipScriptAnalyzer) {
	Invoke-ScriptAnalyzer $ModuleUnderTest.Path -Settings (Join-Path -Path $RepoRoot -ChildPath 'PSScriptAnalyzerSettings.psd1')
}
Pop-Location

# Re-enable default parameters after testing
$PSDefaultParameterValues['Disabled'] = $false
