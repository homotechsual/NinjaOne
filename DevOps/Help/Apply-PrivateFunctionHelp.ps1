#!/usr/bin/env pwsh
<#
.SYNOPSIS
Apply generated help to private functions in bulk with validation.
#>

param(
    [switch]$Force = $false
)

$RepoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\\..')
$semanticHelpPath = Join-Path -Path $PSScriptRoot -ChildPath 'New-SemanticHelp.ps1'
$helpGenerationPath = Join-Path -Path $RepoRoot -ChildPath 'HelpGeneration'
$settingsPath = Join-Path -Path $RepoRoot -ChildPath 'PSScriptAnalyzerSettings.psd1'

# Load database
$dbFile = Get-ChildItem -Path $helpGenerationPath -Filter 'functions_needing_help*.json' | Sort-Object Name -Descending | Select-Object -First 1
$db = Get-Content $dbFile.FullName | ConvertFrom-Json

# Get all private functions
$privateFunctions = @()
$db | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
    if ($db."$_".IsPublic -eq $false) {
        $privateFunctions += $_
    }
}

Write-Host "NinjaOne Private Function Help Application" -ForegroundColor Cyan
Write-Host "=========================================`n" -ForegroundColor Cyan
Write-Host "Target: $($privateFunctions.Count) private functions" -ForegroundColor Yellow

$successful = 0
$failed = 0
$skipped = 0

foreach ($funcName in $privateFunctions | Sort-Object) {
    $funcMetadata = $db."$funcName"
    $filePath = $funcMetadata.File
    
    if (-not (Test-Path $filePath)) {
        Write-Host "  ⚠ SKIPPED: $funcName (file not found)" -ForegroundColor Yellow
        $skipped++
        continue
    }
    
    try {
        $content = Get-Content -Path $filePath -Raw
        $tokens = $null
        $errors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile(
            $filePath, [ref]$tokens, [ref]$errors
        )
        
        if ($errors) {
            Write-Host "  ⚠ PARSE ERROR: $funcName" -ForegroundColor Red
            $failed++
            continue
        }
        
        # Find the function
        $targetFunc = $ast.FindAll(
            { $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] -and 
              $args[0].Name -eq $funcName },
            $false
        ) | Select-Object -First 1
        
        if (-not $targetFunc) {
            Write-Host "  ⚠ NOT FOUND: $funcName in $filePath" -ForegroundColor Yellow
            $skipped++
            continue
        }
        
        # Check for existing help
        $funcStartLine = $targetFunc.Extent.StartLineNumber - 1
        $contentLines = $content -split "`n"
        $searchStart = [Math]::Max(0, $funcStartLine - 50)
        $precedingText = ($contentLines[$searchStart..$funcStartLine] -join "`n")
        
        if ($precedingText -match '(?s)\<#.*?\.SYNOPSIS.*?#\>') {
            Write-Host "  → EXISTING: $funcName" -ForegroundColor Gray
            $skipped++
            continue
        }
        
        # Generate help
        $params = @($funcMetadata.Parameters)
        $help = & $semanticHelpPath `
            -FunctionName $funcName `
            -Parameters $params `
            -FunctionType 'private'
        
        # Insert help
        $helpLines = $help -split "`n"
        $newLines = @($helpLines) + @($contentLines[$funcStartLine..($contentLines.Count - 1)])
        $newContent = $newLines -join "`n"
        
        # Validate syntax
        $testTokens = $null
        $testErrors = $null
        [void][System.Management.Automation.Language.Parser]::ParseInput(
            $newContent, [ref]$testTokens, [ref]$testErrors
        )
        
        if ($testErrors) {
            Write-Host "  ✗ SYNTAX ERROR: $funcName after help insertion" -ForegroundColor Red
            $failed++
            continue
        }
        
        # Write back
        Set-Content -Path $filePath -Value $newContent -Encoding UTF8 -NoNewline
        Write-Host "  ✓ ADDED: $funcName" -ForegroundColor Green
        $successful++
    }
    catch {
        Write-Host "  ✗ ERROR: $funcName - $_" -ForegroundColor Red
        $failed++
    }
}

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "Results:" -ForegroundColor Cyan
Write-Host "  ✓ Successfully added help: $successful" -ForegroundColor Green
Write-Host "  ✗ Failed: $failed" -ForegroundColor $(if ($failed -eq 0) { 'Green' } else { 'Red' })
Write-Host "  → Already had help: $skipped" -ForegroundColor Gray
Write-Host "`nRun PSSA to validate: Get-ChildItem -Path . -Recurse -File -Include '*.ps1','*.psm1' | Where-Object { \$_.FullName -notmatch '\\output\\' -and \$_.FullName -notmatch '\\HelpGeneration\\' } | Invoke-ScriptAnalyzer -Settings '$settingsPath' -IncludeRule 'PSRequiredCommentBasedHelp' | Measure-Object" -ForegroundColor Cyan
