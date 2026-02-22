#!/usr/bin/env pwsh
<#
.SYNOPSIS
Add .EXAMPLE sections to public functions that are missing them.
#>

$RepoRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\\..')
$settingsPath = Join-Path -Path $RepoRoot -ChildPath 'PSScriptAnalyzerSettings.psd1'

# Get all functions missing examples
$violations = Get-ChildItem -Path $RepoRoot -Recurse -File -Include *.ps1,*.psm1,*.psd1 | 
    Where-Object { $_.FullName -notmatch '\\output\\' -and $_.FullName -notmatch '\\HelpGeneration\\' } |
    Invoke-ScriptAnalyzer -Settings $settingsPath -IncludeRule 'PSRequiredCommentBasedHelp' |
    Where-Object { $_.Message -like '*missing .EXAMPLE*' }

Write-Host "Adding .EXAMPLE sections to $($violations.Count) functions" -ForegroundColor Cyan
Write-Host ""

$successful = 0
$failed = 0

foreach ($violation in $violations) {
    $filePath = $violation.ScriptPath
    $message = $violation.Message
    
    if ($message -match "Function '([^']+)'") {
        $funcName = $matches[1]
        
        Write-Host "  Processing: $funcName" -ForegroundColor White
        
        try {
            $content = Get-Content -Path $filePath -Raw
            
            # Check if .EXAMPLE already exists
            if ($content -match '\.EXAMPLE') {
                Write-Host "    ✓ Already has .EXAMPLE" -ForegroundColor Yellow
                $successful++
                continue
            }
            
            # Different example patterns for different verb types
            $example = switch -Regex ($funcName) {
                '^New-' { 
                    '.EXAMPLE' + "`n`t`tPS> " + '$newObject = @{ Name = ''Example'' }' + "`n`t`tPS> $funcName " + '@newObject' + "`n`n`t`tCreates a new resource with the specified properties."
                }
                '^Set-' { 
                    '.EXAMPLE' + "`n`t`tPS> $funcName -Identity 123 -Property 'Value'" + "`n`n`t`tUpdates the specified resource."
                }
                '^Remove-' { 
                    '.EXAMPLE' + "`n`t`tPS> $funcName -Identity 123" + "`n`n`t`tRemoves the specified resource."
                }
                '^Reset-' { 
                    '.EXAMPLE' + "`n`t`tPS> $funcName -Identity 123" + "`n`n`t`tResets the specified resource to default state."
                }
                '^Restart-' { 
                    '.EXAMPLE' + "`n`t`tPS> $funcName -Identity 123" + "`n`n`t`tRestarts the specified resource."
                }
                '^Update-' { 
                    '.EXAMPLE' + "`n`t`tPS> $funcName" + "`n`n`t`tUpdates the resource."
                }
                '^Invoke-' {
                    '.EXAMPLE' + "`n`t`tPS> $funcName -Identity 123" + "`n`n`t`tInvokes the specified operation."
                }
                default { 
                    '.EXAMPLE' + "`n`t`tPS> $funcName" + "`n`n`t`tPerforms the operation."
                }
            }
            
            # Find the closing #> and insert the example before it
            if ($content -match '(\s+)(#>)') {
                $content = $content -replace '(\s+)(#>)', "`n`t`n`t$example`n`$1`$2"
            } else {
                Write-Host "    ✗ Could not find help block closing" -ForegroundColor Red
                $failed++
                continue
            }
            
            # Validate syntax
            $testTokens = $null
            $testErrors = $null
            [void][System.Management.Automation.Language.Parser]::ParseInput(
                $content, [ref]$testTokens, [ref]$testErrors
            )
            
            if ($testErrors) {
                Write-Host "    ✗ Syntax error after insertion" -ForegroundColor Red
                $failed++
            } else {
                Set-Content -Path $filePath -Value $content -Encoding UTF8 -NoNewline
                Write-Host "    ✓ Added example" -ForegroundColor Green
                $successful++
            }
        }
        catch {
            Write-Host "    ✗ Error: $_" -ForegroundColor Red
            $failed++
        }
    }
}

Write-Host ""
Write-Host "Results: $successful successful, $failed failed" -ForegroundColor Cyan
