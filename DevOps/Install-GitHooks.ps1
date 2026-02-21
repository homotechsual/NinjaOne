<#
.SYNOPSIS
    Configures Git to use NinjaOne development hooks.

.DESCRIPTION
    Sets Git's core.hooksPath to DevOps/hooks/ so that hooks are automatically
    enabled for all contributors. This works like Husky in the Node.js ecosystem.

.EXAMPLE
    .\DevOps\Install-GitHooks.ps1
#>
[CmdletBinding()]
param()

# Check if we're in a git repository
if (-not (Test-Path (Join-Path $PSScriptRoot '..' '.git'))) {
    Write-Error "Not in a Git repository. Cannot configure hooks."
    exit 1
}

Write-Host "Configuring Git hooks..." -ForegroundColor Cyan

# Set core.hooksPath to DevOps/hooks (relative to repo root)
$result = git config core.hooksPath 'DevOps/hooks'

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Git hooks configured successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Git will now use hooks from DevOps/hooks/ directory." -ForegroundColor Cyan
    Write-Host "The pre-commit hook will run PSScriptAnalyzer before each commit." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "To disable hooks temporarily, use: git commit --no-verify" -ForegroundColor Yellow
} else {
    Write-Error "Failed to configure Git hooks."
    exit 1
}
