param(
	[string]$SettingsPath
)

$RepoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\\..')
if (-not $SettingsPath) {
	$SettingsPath = Join-Path -Path $RepoRoot -ChildPath 'PSScriptAnalyzerSettings.psd1'
}

$excludeRegex = '\\(CustomRules|output|Modules)\\'

Get-ChildItem -Path $RepoRoot -Recurse -File -Include *.ps1, *.psm1, *.psd1 |
Where-Object {
	$fullName = $_.FullName
	$fullName -notmatch $excludeRegex -and $fullName -notmatch '\\test-rules\.ps1$'
} |
Invoke-ScriptAnalyzer -Settings $SettingsPath
