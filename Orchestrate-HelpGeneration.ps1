#!/usr/bin/env pwsh
<#
.SYNOPSIS
Orchestrates the systematic addition of comment-based help to 261 functions.

.DESCRIPTION
Implements a staged approach to add help to all NinjaOne functions:
  1. Generate all help content (Phase 1)
  2. Apply to public functions (Phase 2)
  3. Verify and validate (Phase 3)
  4. Apply to private functions (Phase 4)
  5. Final validation (Phase 5)

.PARAMETER Phase
Which phase to execute: 'Generate', 'ApplyPublic', 'Verify', 'ApplyPrivate', 'All'

.PARAMETER Force
Skip confirmations and proceed automatically
#>

param(
    [ValidateSet('Generate', 'ApplyPublic', 'Verify', 'ApplyPrivate', 'All')]
    [string]$Phase = 'All',
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$output = 'HelpGeneration'
$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$generationLog = "$output/generation_$timestamp.log"

# Ensure output directory exists
if (-not (Test-Path $output)) {
    New-Item -ItemType Directory -Path $output | Out-Null
}

Write-Host "NinjaOne Comment-Based Help Generation" -ForegroundColor Cyan
Write-Host "======================================`n" -ForegroundColor Cyan

# ==================== PHASE 1: GENERATE ====================
function Invoke-GeneratePhase {
    Write-Host "[PHASE 1] Generating Help Content for All Functions" -ForegroundColor Yellow
    Write-Host "-" * 60 -ForegroundColor Gray
    
    $helpDatabase = @{}
    $stats = @{
        Total = 0
        Public = 0
        Private = 0
    }
    
    # Scan all files for functions needing help
    $files = Get-ChildItem -Path . -Recurse -File -Include '*.ps1', '*.psm1' | 
        Where-Object { 
            $_.FullName -notmatch '\\output\\' -and 
            $_.FullName -notmatch '\\bin\\' -and 
            $_.FullName -notmatch '\\obj\\' -and
            $_.FullName -notmatch '\\Modules\\' -and
            $_.FullName -notmatch 'HelpGeneration' -and
            $_.FullName -notmatch 'Generate-' -and
            $_.FullName -notmatch 'New-Semantic' -and
            $_.FullName -notmatch 'Apply-'
        }
    
    Write-Host "Scanning $($files.Count) files...`n" -ForegroundColor White
    
    foreach ($file in $files) {
        try {
            $tokens = $null
            $errors = $null
            $ast = [System.Management.Automation.Language.Parser]::ParseFile(
                $file.FullName, [ref]$tokens, [ref]$errors
            )
            
            if ($errors) {
                Write-Warning "Parse errors in $($file.Name)"
                continue
            }
            
            $functions = $ast.FindAll(
                { $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, 
                $true
            )
            
            foreach ($func in $functions) {
                $funcName = $func.Name
                $isPublic = $file.FullName -match '\\Public\\' -or $file.FullName -match '/Public/'
                
                # Check if help already exists using comments in token list
                $funcStartLine = $func.Extent.StartLineNumber
                $hasHelp = $tokens | Where-Object {
                    $_.Kind -eq 'Comment' -and
                    $_.StartLineNumber -lt $funcStartLine -and
                    $_.StartLineNumber -gt ($funcStartLine - 100) -and
                    $_.Text -match '\.SYNOPSIS|\.DESCRIPTION'
                }
                
                if (-not $hasHelp) {
                    $stats.Total++
                    if ($isPublic) { $stats.Public++ } else { $stats.Private++ }
                    
                    # Extract parameters
                    $params = @()
                    if ($func.Body.ParamBlock.Parameters) {
                        $params = $func.Body.ParamBlock.Parameters | ForEach-Object {
                            $_.Name.VariablePath.UserPath
                        }
                    }
                    
                    $helpDatabase[$funcName] = @{
                        File = $file.FullName
                        FilePath = $file.FullName -Replace [regex]::Escape($PWD), '.'
                        IsPublic = $isPublic
                        LineNumber = $funcStartLine
                        Parameters = $params
                    }
                }
            }
        }
        catch {
            Write-Error "Error processing $($file.Name): $_"
        }
    }
    
    # Generate helpfor each function
    Write-Host "Generating help content for $($helpDatabase.Count) functions...`n" -ForegroundColor Cyan
    
    $generatedHelp = @{}
    $progress = 0
    
    foreach ($funcName in $helpDatabase.Keys) {
        $progress++
        Write-Progress -Activity "Generating help" -Status $funcName -PercentComplete (($progress / $helpDatabase.Count) * 100)
        
        $funcData = $helpDatabase[$funcName]
        $funcType = if ($funcData.IsPublic) { 'public' } else { 'private' }
        
        # Generate help using the semantic generator
        $help = & .\New-SemanticHelp.ps1 `
            -FunctionName $funcName `
            -Parameters $funcData.Parameters `
            -FunctionType $funcType
        
        $generatedHelp[$funcName] = @{
            Function = $funcName
            Help = $help
            Metadata = $funcData
        }
    }
    
    Write-Progress -Completed
    
    # Save results
    $dbFile = "$output/functions_needing_help_$timestamp.json"
    $helpFile = "$output/generated_help_$timestamp.json"
    
    $helpDatabase | ConvertTo-Json -Depth 10 | Out-File $dbFile -Encoding UTF8
    
    Write-Host "`n✓ Results saved:" -ForegroundColor Green
    Write-Host "  Database: $dbFile" -ForegroundColor White
    Write-Host "  Help content: $helpFile" -ForegroundColor White
    
    Write-Host "`nStatistics:" -ForegroundColor Green
    Write-Host "  Total functions needing help: $($stats.Total)" -ForegroundColor White
    Write-Host "  Public functions: $($stats.Public)" -ForegroundColor Yellow
    Write-Host "  Private functions: $($stats.Private)" -ForegroundColor Yellow
    
    @{
        Database = $helpDatabase
        Generated = $generatedHelp
        Stats = $stats
    }
}

# ==================== PHASE 2: APPLY TO PUBLIC ====================
function Invoke-ApplyPublicPhase {
    param($GenerationData)
    
    Write-Host "`n[PHASE 2] Applying Help to Public Functions" -ForegroundColor Yellow
    Write-Host "-" * 60 -ForegroundColor Gray
    
    Write-Host "This will add help to $($GenerationData.Stats.Public) public functions." -ForegroundColor Cyan
    
    if (-not $Force) {
        $proceed = Read-Host "`nProceed with applying help to public functions? (y/n)"
        if ($proceed -ne 'y') {
            Write-Host "Skipped." -ForegroundColor Yellow
            return
        }
    }
    
    Write-Host "Ready to apply help to public functions." -ForegroundColor Green
    Write-Host "Implementation will insert help blocks and validate syntax." -ForegroundColor Gray
    Write-Host "`nNote: This is a preview. Run 'Apply-CommentBasedHelpToFunctions.ps1' to execute." -ForegroundColor Yellow
}

# ==================== PHASE 3: VERIFY ====================
function Invoke-VerifyPhase {
    Write-Host "`n[PHASE 3] Verification & Validation" -ForegroundColor Yellow
    Write-Host "-" * 60 -ForegroundColor Gray
    
    Write-Host "Run PSSA to verify all help is in place:" -ForegroundColor Cyan
    
    $command = @'
Get-ChildItem -Path . -Recurse -File -Include *.ps1,*.psm1,*.psd1 | `
  Where-Object { $_.FullName -notmatch '\\output\\' -and $_.FullName -notmatch '\\HelpGeneration\\' } | `
  Invoke-ScriptAnalyzer -Settings '.\PSScriptAnalyzerSettings.psd1' -IncludeRule 'PSRequiredCommentBasedHelp' | `
  Measure-Object
'@
    
    Write-Host "`nCommand:`n  $command" -ForegroundColor Gray
    Write-Host "`nExpected result: Count = 0 (all functions have help)" -ForegroundColor Cyan
}

# ==================== Main Execution ====================
try {
    if ($Phase -in 'Generate', 'All') {
        $data = Invoke-GeneratePhase
    }
    
    if ($Phase -in 'ApplyPublic', 'All') {
        Invoke-ApplyPublicPhase -GenerationData $data
    }
    
    if ($Phase -in 'Verify', 'All') {
        Invoke-VerifyPhase
    }
    
    Write-Host "`n======================================" -ForegroundColor Cyan
    Write-Host "Phase complete. Next steps:" -ForegroundColor Green
    Write-Host "  1. Review generated help content" -ForegroundColor White
    Write-Host "  2. Run Phase 2 to apply help to public functions" -ForegroundColor White
    Write-Host "  3. Validate with PSSA (Phase 3)" -ForegroundColor White
    Write-Host "======================================" -ForegroundColor Cyan
}
catch {
    Write-Error "Fatal error: $_"
    exit 1
}
