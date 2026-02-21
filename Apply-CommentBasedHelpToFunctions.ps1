#!/usr/bin/env pwsh
<#
.SYNOPSIS
Applies generated help to all functions missing comment-based help.

.DESCRIPTION
Scans PowerShell files, identifies functions without help, generates semantic help content,
and inserts it into each function. Processes functions systematically and validates results.

.EXAMPLE
.\Apply-CommentBasedHelpToFunctions.ps1 -SourcePath .\Source\Public -Confirm
#>

param(
    [string]$SourcePath = '.',
    [switch]$Confirm,
    [int]$BatchSize = 10
)

# Import the semantic help generator
. .\New-SemanticHelp.ps1

$script:totalProcessed = 0
$script:totalModified = 0
$script:failureLog = @()

function Test-FunctionHasHelp {
    param([string]$FileContent, [int]$LineNumber)
    
    $lines = $FileContent -split "`n"
    $searchStart = [Math]::Max(0, $LineNumber - 50)
    $searchEnd = $LineNumber
    
    $precedingLines = $lines[$searchStart..$searchEnd] | Where-Object { $_ -match '<#|\.SYNOPSIS|\.DESCRIPTION' }
    return $precedingLines.Count -gt 0
}

function Get-FunctionParameters {
    param([System.Management.Automation.Language.FunctionDefinitionAst]$FunctionAst)
    
    $params = @()
    if ($FunctionAst.Body.ParamBlock.Parameters) {
        foreach ($param in $FunctionAst.Body.ParamBlock.Parameters) {
            $params += $param.Name.VariablePath.UserPath
        }
    }
    return $params
}

function Get-FunctionType {
    param([string]$FilePath)
    
    if ($FilePath -match '\\Public\\' -or $FilePath -match '/Public/') {
        return 'public'
    }
    return 'private'
}

function Insert-HelpIntoFile {
    param(
        [string]$FilePath,
        [System.Management.Automation.Language.FunctionDefinitionAst]$FunctionAst,
        [string]$HelpContent
    )
    
    $fileContent = Get-Content -Path $FilePath -Raw
    $lines = $fileContent -split "`n"
    
    # Find the line with "function" keyword
    $functionLineIndex = $FunctionAst.Extent.StartLineNumber - 1
    
    # Check if there's already help above it
    $checkAbove = [Math]::Max(0, $functionLineIndex - 50)
    $precedingText = ($lines[$checkAbove..$functionLineIndex] -join "`n")
    
    if ($precedingText -match '<#[\s\S]*?#>' -or $precedingText -match '\.SYNOPSIS') {
        Write-Verbose "Help already exists for $($FunctionAst.Name) in $FilePath"
        return $false
    }
    
    # Prepare new lines with help
    $helpLines = $HelpContent -split "`n"
    $newLines = @($helpLines) + @($lines[$functionLineIndex..($lines.Count - 1)])
    
    # Join and save
    $newContent = $newLines -join "`n"
    Set-Content -Path $FilePath -Value $newContent -Encoding UTF8 -NoNewline
    
    return $true
}

<#
.SYNOPSIS
    Processes a PowerShell file to apply comment-based help.
.DESCRIPTION
    Parses a PowerShell file and applies generated comment-based help to functions.
#>
function Process-File {
    param([System.IO.FileInfo]$File)
    
    try {
        $tokens = $null
        $errors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($File.FullName, [ref]$tokens, [ref]$errors)
        
        if ($errors) {
            Write-Warning "Parse errors in $($File.Name): $($errors[0].Message)"
            $script:failureLog += "PARSE_ERROR: $($File.FullName) - $($errors[0].Message)"
            return 0
        }
        
        $functions = $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)
        $modified = 0
        
        foreach ($func in $functions) {
            $script:totalProcessed++
            
            # Check if function already has help
            if (-not (Test-FunctionHasHelp -FileContent (Get-Content $File.FullName -Raw) -LineNumber $func.Extent.StartLineNumber)) {
                
                # Generate semantic help
                $params = Get-FunctionParameters -FunctionAst $func
                $funcType = Get-FunctionType -FilePath $File.FullName
                
                $help = & .\New-SemanticHelp.ps1 `
                    -FunctionName $func.Name `
                    -Parameters $params `
                    -FunctionType $funcType
                
                # Insert help into file
                if (Insert-HelpIntoFile -FilePath $File.FullName -FunctionAst $func -HelpContent $help) {
                    Write-Host "  ✓ Added help to: $($func.Name)" -ForegroundColor Green
                    $modified++
                    $script:totalModified++
                }
            }
        }
        
        return $modified
    }
    catch {
        Write-Error "Error processing $($File.FullName): $_"
        $script:failureLog += "PROCESS_ERROR: $($File.FullName) - $_"
        return 0
    }
}

# Main execution
Write-Host "NinjaOne Comment-Based Help Application Tool" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

$files = Get-ChildItem -Path $SourcePath -Recurse -File -Include '*.ps1', '*.psm1' | 
    Where-Object { 
        $_.FullName -notmatch '\\output\\' -and 
        $_.FullName -notmatch '\\bin\\' -and 
        $_.FullName -notmatch '\\obj\\' -and
        $_.FullName -notmatch '\\Modules\\' -and
        $_.FullName -notmatch 'Generate-' -and
        $_.FullName -notmatch 'New-Semantic'
    }

Write-Host "Found $($files.Count) files to process in: $SourcePath" -ForegroundColor Yellow
Write-Host "Processing functions in batches of $BatchSize...`n" -ForegroundColor Yellow

$batch = @()
foreach ($file in $files) {
    $batch += $file
    
    if ($batch.Count -ge $BatchSize) {
        Write-Host "Processing batch of $($batch.Count) files..." -ForegroundColor Cyan
        
        $batchModified = 0
        foreach ($f in $batch) {
            $batchModified += Process-File -File $f
        }
        
        Write-Host "  Batch complete: $batchModified functions updated" -ForegroundColor Green
        Write-Host ""
        
        $batch = @()
    }
}

# Process remaining files
if ($batch.Count -gt 0) {
    Write-Host "Processing final batch of $($batch.Count) files..." -ForegroundColor Cyan
    foreach ($f in $batch) {
        Process-File -File $f | Out-Null
    }
    Write-Host "  Final batch complete" -ForegroundColor Green
}

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  Total functions scanned: $($script:totalProcessed)" -ForegroundColor White
Write-Host "  Functions helped: $($script:totalModified)" -ForegroundColor Green
Write-Host "  Failures: $($script:failureLog.Count)" -ForegroundColor $(if ($script:failureLog.Count -eq 0) { 'Green' } else { 'Red' })

if ($script:failureLog.Count -gt 0) {
    Write-Host "`nFailure Log:" -ForegroundColor Red
    $script:failureLog | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
}

Write-Host "`nNext step: Run full PSSA to verify help compliance." -ForegroundColor Cyan
