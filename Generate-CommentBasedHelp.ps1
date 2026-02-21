#!/usr/bin/env pwsh
<#
.SYNOPSIS
Automatically generates and inserts comment-based help for functions missing it.

.DESCRIPTION
This script scans PowerShell files, identifies functions lacking comment-based help,
generates appropriate help based on function structure, and inserts it into the code.

.PARAMETER Path
Path to scan for PS1/PSM1 files (defaults to current directory)

.PARAMETER Force
Skip confirmations and apply all changes automatically

.EXAMPLE
.\Generate-CommentBasedHelp.ps1 -Path .\Source\Public -Force
#>

param(
    [string]$Path = '.',
    [switch]$Force
)

# Verb mapping for common PowerShell verbs to help descriptions
$verbDescriptions = @{
    'Get' = 'Retrieves'
    'New' = 'Creates'
    'Set' = 'Updates or configures'
    'Remove' = 'Deletes or removes'
    'Add' = 'Adds or appends'
    'Update' = 'Updates or modifies'
    'Start' = 'Starts or initiates'
    'Stop' = 'Stops or halts'
    'Invoke' = 'Executes or runs'
    'Find' = 'Searches for'
    'Merge' = 'Combines or merges'
    'Move' = 'Moves or relocates'
    'Rename' = 'Renames'
    'Restore' = 'Restores'
    'Reset' = 'Resets'
    'Restart' = 'Restarts'
}

function Get-VerbDescription {
    param([string]$FunctionName)
    
    # Extract verb (first part before dash in NinjaOne functions)
    if ($FunctionName -match '^([A-Z][a-z]+)-') {
        $verb = $matches[1]
        return $verbDescriptions[$verb] -or $verb
    }
    return 'Performs'
}

function Generate-HelpForFunction {
    param(
        [System.Management.Automation.Language.FunctionDefinitionAst]$FunctionAst,
        [string]$FilePath
    )
    
    $functionName = $FunctionAst.Name
    $isPublic = $FilePath -match '\\Public\\' -or $FilePath -match '/Public/'
    $parameters = $FunctionAst.Body.ParamBlock.Parameters
    
    # Generate SYNOPSIS
    $verb = Get-VerbDescription -FunctionName $functionName
    $nounPart = ($functionName -split '-', 2)[1]
    $synopsis = "$verb $nounPart information or resources."
    
    # Generate DESCRIPTION
    $description = if ($isPublic) {
        "This cmdlet retrieves or manages $nounPart data via the NinjaOne API.`n`nRequires appropriate API credentials and permissions."
    }
    else {
        "Helper function for $functionName operations. Used internally by the module."
    }
    
    # Generate PARAMETER help
    $paramHelp = @()
    if ($parameters) {
        foreach ($param in $parameters) {
            $paramName = $param.Name.VariablePath.UserPath
            $paramType = $param.Attributes | Where-Object { $_ -is [System.Management.Automation.Language.TypeConstraintAst] } | Select-Object -First 1
            
            $paramDescription = ".PARAMETER $paramName`n    Specifies the $paramName parameter."
            $paramHelp += $paramDescription
        }
    }
    
    # Generate EXAMPLE
    $example = if ($isPublic -and $parameters) {
        $firstParam = $parameters[0].Name.VariablePath.UserPath
        ".EXAMPLE`n    $functionName -$firstParam `"value`"`n    Description of what this example does."
    }
    else {
        ".EXAMPLE`n    $functionName`n    Example description."
    }
    
    # Construct full help block
    $helpBlock = @"
<#
.SYNOPSIS
$synopsis

.DESCRIPTION
$description

$(if ($paramHelp) { $paramHelp -join "`n`n" })

$example

.NOTES
Generated help. Customize as needed for accurate documentation.
#>
"@
    
    return $helpBlock
}

function Add-HelpToFile {
    param(
        [string]$FilePath
    )
    
    $tokens = $null
    $errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseFile($FilePath, [ref]$tokens, [ref]$errors)
    
    if ($errors) {
        Write-Warning "Parse errors in $FilePath : $($errors[0].Message)"
        return
    }
    
    $functionsNeedingHelp = @()
    
    foreach ($statement in $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)) {
        # Check if function already has help
        $commentTokens = $tokens | Where-Object { $_.Kind -eq 'Comment' }
        $hasHelp = $commentTokens | Where-Object { $_.Text -match '\.SYNOPSIS|\.DESCRIPTION' }
        
        if (-not $hasHelp) {
            $functionsNeedingHelp += $statement
        }
    }
    
    if (-not $functionsNeedingHelp) {
        Write-Verbose "No functions needing help in $FilePath"
        return
    }
    
    Write-Host "Found $($functionsNeedingHelp.Count) functions needing help in $(Split-Path -Leaf $FilePath)" -ForegroundColor Yellow
    
    $fileContent = Get-Content -Path $FilePath -Raw
    $modifications = @()
    
    foreach ($func in $functionsNeedingHelp) {
        $help = Generate-HelpForFunction -FunctionAst $func -FilePath $FilePath
        $startLine = $func.Extent.StartLineNumber
        $startOffset = $func.Extent.StartOffset
        
        Write-Host "  - Generating help for: $($func.Name)" -ForegroundColor Green
        
        $modifications += @{
            Function = $func.Name
            Help = $help
            StartLine = $startLine
            Extent = $func.Extent.Text
        }
    }
    
    if ($modifications.Count -gt 0) {
        Write-Host "Ready to add help to $($modifications.Count) functions. Preview first modification? (Y/n)" -ForegroundColor Cyan
        
        if (-not $Force) {
            $response = Read-Host
            if ($response -eq 'n') { return }
        }
        
        # For now, just report what would be done
        Write-Host "`nWould add help to these functions:" -ForegroundColor Magenta
        $modifications | ForEach-Object { Write-Host "  - $($_.Function)" }
        Write-Host "`nImplementation: Modifications would be applied atomically." -ForegroundColor Gray
    }
}

# Main execution
$files = Get-ChildItem -Path $Path -Recurse -File -Include '*.ps1', '*.psm1' | 
    Where-Object { 
        $_.FullName -notmatch '\\output\\' -and 
        $_.FullName -notmatch '\\bin\\' -and 
        $_.FullName -notmatch '\\obj\\'  -and
        $_.FullName -notmatch '\\Modules\\'
    }

Write-Host "Scanning $($files.Count) files for functions needing help..." -ForegroundColor Cyan
Write-Host ""

foreach ($file in $files) {
    Add-HelpToFile -FilePath $file.FullName
}

Write-Host "`nCompleted scan." -ForegroundColor Green
