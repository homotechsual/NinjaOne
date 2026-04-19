param(
	[string]$settingsPath
)

$RepoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\\..')
if (-not $settingsPath) {
	$settingsPath = Join-Path -Path $RepoRoot -ChildPath 'PSScriptAnalyzerSettings.psd1'
}

$settings = Import-PowerShellDataFile -Path $settingsPath
$camelCaseRule = 'Measure-RequireCamelCaseParameterName'
$nonPublicSettings = @{
	CustomRulePath = $settings.CustomRulePath
	Severity = $settings.Severity
	IncludeRules = [string[]]@($settings.IncludeRules | Where-Object { $_ -ne $camelCaseRule })
	Rules = $settings.Rules
}

$excludeRegex = '\\(CustomRules|output|Modules)\\'
$publicRoot = Join-Path -Path $RepoRoot -ChildPath 'Source\Public'

Invoke-ScriptAnalyzer -Path $publicRoot -Recurse -Settings $settingsPath

# Using Get-ChildItem approach to ensure all files in subdirectories are scanned
# Note: When using Invoke-ScriptAnalyzer with a directory path, you must add -Recurse
# to scan subdirectories. Example: Invoke-ScriptAnalyzer -Path $folder -Recurse -Settings $settingsPath
Get-ChildItem -Path $RepoRoot -Recurse -File -Include *.ps1, *.psm1, *.psd1 |
Where-Object {
	$fullName = $_.FullName
	$fullName -notmatch $excludeRegex -and
	$fullName -notmatch '\\test-rules\.ps1$' -and
	$fullName -notlike "$publicRoot*"
} |
Invoke-ScriptAnalyzer -Settings $nonPublicSettings
