param(
	[string]$SettingsPath = '.\PSScriptAnalyzerSettings.psd1'
)

$excludeRegex = '\\(CustomRules|output|Modules)\\'

Get-ChildItem -Path . -Recurse -File -Include *.ps1, *.psm1, *.psd1 |
	Where-Object {
		$fullName = $_.FullName
		$fullName -notmatch $excludeRegex -and $fullName -notmatch '\\test-rules\.ps1$'
	} |
	Invoke-ScriptAnalyzer -Settings $SettingsPath
