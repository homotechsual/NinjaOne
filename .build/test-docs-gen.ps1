# Test documentation generation to debug the fork issue
Import-Module '.\Modules\Alt3.Docusaurus.Powershell\1.0.37\Alt3.Docusaurus.Powershell.psd1' -Force

$ErrorActionPreference = 'Continue'
$modulePath = '.\Output\NinjaOne\2.1.0\NinjaOne.psd1'
$ExcludeFiles = Get-ChildItem -Path "$($PSScriptRoot)\..\Source\Private" -Filter '*.ps1' -Recurse | ForEach-Object { [System.IO.Path]::GetFileNameWithoutExtension($_.FullName) }

Write-Host "Module path: $modulePath"
Write-Host "Exclude count: $($ExcludeFiles.Count)"
Write-Host "First few excludes: $($ExcludeFiles | Select-Object -First 3)"

$error.clear()
try {
    New-DocusaurusHelp `
        -Module $modulePath `
        -DocsFolder '.\test-docs' `
        -Exclude $ExcludeFiles `
        -Sidebar 'commandlets' `
        -GroupByVerb `
        -NoPlaceHolderExamples `
        -ErrorAction Stop
    Write-Host "Success!" -ForegroundColor Green
} catch {
    Write-Host "Error caught!" -ForegroundColor Red
    Write-Host $_.Exception.Message
    Write-Host "Full error:" -ForegroundColor Yellow
    $_ | Format-List -Force
}
