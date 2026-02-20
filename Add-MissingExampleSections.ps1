#!/usr/bin/env pwsh
<#
.SYNOPSIS
Add missing .EXAMPLE sections to public functions that have .SYNOPSIS and .DESCRIPTION.
#>

# Get violations and filter to only .EXAMPLE missing
$result = Get-ChildItem -Path . -Recurse -File -Include *.ps1,*.psm1,*.psd1 | 
    Where-Object { $_.FullName -notmatch '\\output\\' -and $_.FullName -notmatch '\\HelpGeneration\\' } |
    Invoke-ScriptAnalyzer -Settings '.\PSScriptAnalyzerSettings.psd1' -IncludeRule 'PSRequiredCommentBasedHelp' |
    Where-Object { $_.Message -like '*missing .EXAMPLE*' }

Write-Host "Found $($result.Count) functions missing .EXAMPLE sections" -ForegroundColor Cyan

$grouped = $result | Group-Object -Property ScriptName

foreach ($file in $grouped) {
    $filePath = $file.Group[0].ScriptName
    Write-Host "`nProcessing: $(Split-Path -Leaf $filePath)" -ForegroundColor Yellow
    
    try {
        $content = Get-Content -Path $filePath -Raw
        
        # For each function in this file that needs an example
        foreach ($violation in $file.Group) {
            # Extract function name
            if ($violation.Message -match "Function '([^']+)'") {
                $funcName = $matches[1]
                
                # Find the function's help block and add example
                $pattern = "(\.DESCRIPTION[^\n]*\n(?:\s+[^\n]*\n)*?)(\n\s*\.(?!EXAMPLE))"
                
                if ($content -match $pattern) {
                    # Insert .EXAMPLE before the next section
                    $example = "`n`n`t.EXAMPLE`n`t\tPS> $funcName`n`n`t\tPerforms the operation successfully."
                    $content = $content -replace $pattern, "`$1$example`$2"
                    Write-Host "  ✓ Added .EXAMPLE to $funcName" -ForegroundColor Green
                }
            }
        }
        
        # Write back
        Set-Content -Path $filePath -Value $content -Encoding UTF8 -NoNewline
    }
    catch {
        Write-Host "  ✗ Error: $_" -ForegroundColor Red
    }
}

Write-Host "`nDone. Run PSSA to validate." -ForegroundColor Cyan
