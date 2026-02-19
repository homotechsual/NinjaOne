# Test with official Alt3.Docusaurus.PowerShell  
Import-Module 'Alt3.Docusaurus.Powershell' -Force

$ErrorActionPreference = 'Continue'
$modulePath = '.\Output\NinjaOne\2.0.5\NinjaOne.psd1'
$ExcludeFiles = Get-ChildItem -Path "$($PSScriptRoot)\..\Source\Private" -Filter '*.ps1' -Recurse | ForEach-Object { [System.IO.Path]::GetFileNameWithoutExtension($_.FullName) }

Write-Host "Using OFFICIAL Alt3.Docosaurus.PowerShell version 1.0.37"
Write-Host "Module path: $modulePath"
Write-Host "Exclude count: $($ExcludeFiles.Count)"

$error.clear()
try {
    New-DocusaurusHelp `
        -Module $modulePath `
        -DocsFolder '.\test-docs-official' `
        -Exclude $ExcludeFiles `
        -Sidebar 'commandlets' `
        -GroupByVerb `
        -NoPlaceHolderExamples `
        -ErrorAction Stop
    Write-Host "Success with OFFICIAL module!" -ForegroundColor Green
} catch {
    Write-Host "Error with OFFICIAL module!" -ForegroundColor Red
    Write-Host $_.Exception.Message
}
