<#
.SYNOPSIS
    Fixes leading space before PS> prompts in generated .mdx documentation files.

.DESCRIPTION
    Post-processes .mdx files to remove the leading space that appears before PowerShell
    prompts (PS>) in code examples. This space is introduced during the Alt3 module's
    markdown conversion process.

.EXAMPLE
    .\Fix-DocumentationWhitespace.ps1 -DocsPath '.\docs\NinjaOne\commandlets'
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$DocsPath = '.\docs\NinjaOne\commandlets'
)

$RepoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$FullDocsPath = Join-Path -Path $RepoRoot -ChildPath $DocsPath

if (-not (Test-Path -Path $FullDocsPath)) {
    Write-Warning "Documentation path not found: $FullDocsPath"
    return
}

Write-Host "Fixing whitespace in documentation files..." -ForegroundColor Cyan

$mdxFiles = Get-ChildItem -Path $FullDocsPath -Filter '*.mdx' -Recurse
$fixed = 0
$total = $mdxFiles.Count

foreach ($file in $mdxFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    
    # Replace leading space before PS> prompts within code blocks
    # Match: (newline)(space)(PS>)
    # Replace with: (newline)(PS>) - removing the space
    $originalContent = $content
    $content = $content -replace '(\n) (PS>)', '$1$2'
    
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
        $fixed++
        Write-Verbose "Fixed: $($file.Name)"
    }
}

Write-Host "✓ Fixed $fixed of $total files" -ForegroundColor Green
