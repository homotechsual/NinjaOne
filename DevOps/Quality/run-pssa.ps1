param(
	[string]$SettingsPath
)

$RepoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\\..')
if (-not $SettingsPath) {
	$SettingsPath = Join-Path -Path $RepoRoot -ChildPath 'PSScriptAnalyzerSettings.psd1'
}

$excludeRegex = '\\(CustomRules|output|Modules)\\'

# Using Get-ChildItem approach to ensure all files in subdirectories are scanned
# Note: When using Invoke-ScriptAnalyzer with a directory path, you must add -Recurse
# to scan subdirectories. Example: Invoke-ScriptAnalyzer -Path $folder -Recurse -Settings $SettingsPath
Get-ChildItem -Path $RepoRoot -Recurse -File -Include *.ps1, *.psm1, *.psd1 |
Where-Object {
	$fullName = $_.FullName
	$fullName -notmatch $excludeRegex -and $fullName -notmatch '\\test-rules\.ps1$'
} |
Invoke-ScriptAnalyzer -Settings $SettingsPath
