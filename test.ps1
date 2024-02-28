#requires -Module PowerShellGet, @{ ModuleName = 'Pester'; ModuleVersion = '5.5.0'; MaximumVersion = '5.999' }
using namespace Microsoft.PackageManagement.Provider.Utility
using namespace System.Management.Automation
param(
    [switch]$SkipScriptAnalyzer,
    [switch]$IncludeVSCodeMarker
)
Push-Location $PSScriptRoot
$ModulePath = Resolve-Path -Path '.\Output\*\*' | Sort-Object -Property BaseName | Select-Object -Last 1 -ExpandProperty Path
$ModuleName = Get-ChildItem -Path ('{0}\*' -f $ModulePath) -Filter '*.psd1' -Exclude 'build.psd1' | Select-Object -ExpandProperty BaseName
# Disable default parameters during testing, just in case
$PSDefaultParameterValues += @{}
$PSDefaultParameterValues['Disabled'] = $true
# Find a built module as a version-numbered folder:
$VersionDirectory = Resolve-Path -Path '.\Output\*\*'
if ($VersionDirectory) {
    $TestDirectory = $VersionDirectory | Sort-Object { $_.Name -as [SemanticVersion[]] } | Select-Object -Last 1
} else {
    $TestDirectory = Get-Item -Path '.\Source'
}
$FoundModule = $TestDirectory | Get-ChildItem -Filter ('{0}.psd1' -f $ModuleName)
if (!$FoundModule) {
    throw ('Cannot find {0}.psd1 in {1}' -f $ModuleName, $TestDirectory.FullName)
}
Remove-Module $ModuleName -ErrorAction Ignore -Force
$ModuleUnderTest = Import-Module $FoundModule.FullName -PassThru -Force -DisableNameChecking -Verbose:$false
Write-Verbose ('Invoke-Pester for Module {0} version {1}' -f $ModuleUnderTest, $ModuleUnderTest.Version)
$PesterConfiguration = New-PesterConfiguration
$PesterConfiguration.CodeCoverage.Enabled = $true
$PesterConfiguration.CodeCoverage.OutputPath = '.\.artifacts\CodeCoverage.xml'
$PesterConfiguration.Output.Verbosity = 'Detailed'
$PesterConfiguration.Run.Path = '.\Tests'
$PesterConfiguration.Run.PassThru = $true
$PesterConfiguration.TestResult.Enabled = $true
$PesterConfiguration.TestResult.OutputPath = '.\.artifacts\TestResults.xml'
$PesterConfiguration.TestResult.OutputFormat = 'JUnitXML'
if ($IncludeVSCodeMarker) {
    $PesterConfiguration.VSCodeMarker = $true
}

Invoke-Pester -Configuration $PesterConfiguration

if (-not $SkipScriptAnalyzer) {
    Invoke-ScriptAnalyzer $ModuleUnderTest.Path -Settings .\PSScriptAnalyzerSettings.psd1
}
Pop-Location

# Re-enable default parameters after testing
$PSDefaultParameterValues['Disabled'] = $false
