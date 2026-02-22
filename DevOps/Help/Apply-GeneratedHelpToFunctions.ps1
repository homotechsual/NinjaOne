#!/usr/bin/env pwsh
<#
.SYNOPSIS
Apply help to specific functions from the generated database.

.DESCRIPTION
Takes functions from the help generation database and applies
the generated help blocks to the actual files.

.PARAMETER FunctionNames
List of function names to update

.PARAMETER Force
Skip confirmations

.EXAMPLE
.\DevOps\Help\Apply-GeneratedHelpToFunctions.ps1 -FunctionNames @('Get-NinjaOneDevices')
#>

param(
    [string[]]$FunctionNames,
    [switch]$Force
)

$RepoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\\..')
$semanticHelpPath = Join-Path -Path $PSScriptRoot -ChildPath 'New-SemanticHelp.ps1'
$helpGenerationPath = Join-Path -Path $RepoRoot -ChildPath 'HelpGeneration'

function Insert-HelpBeforeFunction {
    param(
        [string]$FilePath,
        [string]$FunctionName,
        [string]$HelpContent
    )
    
    Write-Host "  Processing: $FunctionName" -ForegroundColor White
    
    # Read file as array of lines
    $lines = @(Get-Content -Path $FilePath -Encoding UTF8)
    $content = $lines -join "`n"
    
    # Parse to find function
    $tokens = $null
    $errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseFile(
        $FilePath, [ref]$tokens, [ref]$errors
    )
    
    if ($errors) {
        Write-Error "Parse errors in $FilePath"
        return $false
    }
    
    # Find the target function
    $targetFunc = $ast.FindAll(
        { $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] -and 
          $args[0].Name -eq $FunctionName },
        $false
    ) | Select-Object -First 1
    
    if (-not $targetFunc) {
        Write-Warning "Function $FunctionName not found in $FilePath"
        return $false
    }
    
    # Check if help already exists
    $funcLineNum = $targetFunc.Extent.StartLineNumber - 1
    $searchStart = [Math]::Max(0, $funcLineNum - 50)
    $precedingContent = ($lines[$searchStart..$funcLineNum] -join "`n")
    
    if ($precedingContent -match '<#[\s\S]*?\.SYNOPSIS' -or $precedingContent -match '\.SYNOPSIS') {
        Write-Warning "Help already exists for $FunctionName"
        return $false
    }
    
    # Insert help: Build new content
    $beforeFunction = $lines[0..($funcLineNum - 1)] -join "`n"
    $functionAndAfter = $lines[$funcLineNum..($lines.Count - 1)] -join "`n"
    
    # Add newline before help if there's content before it
    if ($beforeFunction.Trim()) {
        $newContent = $beforeFunction + "`n`n" + $HelpContent + "`n" + $functionAndAfter
    }
    else {
        $newContent = $HelpContent + "`n" + $functionAndAfter
    }
    
    # Validate syntax
    $testTokens = $null
    $testErrors = $null
    [void][System.Management.Automation.Language.Parser]::ParseInput(
        $newContent, [ref]$testTokens, [ref]$testErrors
    )
    
    if ($testErrors) {
        Write-Error "Syntax error after inserting help: $($testErrors[0].Message)"
        return $false
    }
    
    # Write back
    Set-Content -Path $FilePath -Value $newContent -Encoding UTF8 -NoNewline
    Write-Host "    ✓ Help added and validated" -ForegroundColor Green
    return $true
}

# Main
Write-Host "NinjaOne Help Application Tool" -ForegroundColor Cyan
Write-Host "==============================`n" -ForegroundColor Cyan

# Load database
$dbFile = Get-ChildItem -Path $helpGenerationPath -Filter 'functions_needing_help*.json' | Sort-Object Name -Descending | Select-Object -First 1
if (-not $dbFile) {
    Write-Error "No help generation database found. Run DevOps/Help/Orchestrate-HelpGeneration.ps1 first."
    exit 1
}

Write-Host "Using database: $(Split-Path $dbFile.FullName -Leaf)`n" -ForegroundColor Yellow

$db = Get-Content $dbFile.FullName | ConvertFrom-Json
$allFunctions = $db | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name

# If no functions specified, show public functions only
if (-not $FunctionNames -or $FunctionNames.Count -eq 0) {
    $FunctionNames = @(
        'Invoke-NinjaOneDocumentTemplatesArchive',
        'Invoke-NinjaOneDocumentTemplatesRestore',
        'Invoke-NinjaOneOrganisationDocumentArchive',
        'Invoke-NinjaOneOrganisationDocumentRestore',
        'Invoke-NinjaOneOrganisationDocumentsArchive',
        'Invoke-NinjaOneOrganisationDocumentsRestore',
        'Invoke-NinjaOneOrganisationRestore'
    )
}

Write-Host "Will apply help to $($FunctionNames.Count) functions:`n" -ForegroundColor Cyan
$FunctionNames | ForEach-Object { Write-Host "  - $_" -ForegroundColor White }

if (-not $Force) {
    Write-Host ""
    $proceed = Read-Host "Proceed? (y/n)"
    if ($proceed -ne 'y') {
        Write-Host "Cancelled." -ForegroundColor Yellow
        exit 0
    }
}

Write-Host "`nApplying help...`n" -ForegroundColor Cyan

$successCount = 0
$failureCount = 0

foreach ($funcName in $FunctionNames) {
    if ($funcName -notin $allFunctions) {
        Write-Warning "Function $funcName not in database"
        $failureCount++
        continue
    }
    
    $funcMetadata = $db."$funcName"
    $filePath = $funcMetadata.File
    
    # Generate help
    $params = @($funcMetadata.Parameters)
    $funcType = if ($funcMetadata.IsPublic) { 'public' } else { 'private' }
    
    $helpContent = & $semanticHelpPath `
        -FunctionName $funcName `
        -Parameters $params `
        -FunctionType $funcType
    
    # Apply help
    if (Insert-HelpBeforeFunction -FilePath $filePath -FunctionName $funcName -HelpContent $helpContent) {
        $successCount++
    }
    else {
        $failureCount++
    }
}

Write-Host "`n==============================" -ForegroundColor Cyan
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  Successful: $successCount" -ForegroundColor Green
Write-Host "  Failed: $failureCount" -ForegroundColor $(if ($failureCount -eq 0) { 'Green' } else { 'Red' })
Write-Host "`nNext: Run PSSA to validate" -ForegroundColor Cyan
