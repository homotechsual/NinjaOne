[CmdletBinding()]
param(
	[Parameter()]
	[ValidateRange(1, 5000)]
	[Int]$Last = 45,
	[Parameter()]
	[ValidateSet('None', 'Normal', 'Detailed', 'Diagnostic')]
	[String]$Verbosity = 'Normal',
	[Parameter()]
	[Switch]$SkipScriptAnalyzer = $true
)

$TestScriptPath = Join-Path -Path $PSScriptRoot -ChildPath 'test.ps1'

$TestParams = @{
	Suite = 'public'
	Verbosity = $Verbosity
}

if ($SkipScriptAnalyzer) {
	$TestParams.SkipScriptAnalyzer = $true
}

& $TestScriptPath @TestParams 2>&1 | Select-Object -Last $Last
