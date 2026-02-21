# Git Hooks

This directory contains Git hooks for the NinjaOne project.

## Installation

To configure Git to use these hooks, run:

```powershell
.\DevOps\Install-GitHooks.ps1
```

This sets `core.hooksPath` to point to this directory, similar to how Husky works in Node.js projects. Hooks are then automatically enabled for all contributors without copying files.

## Available Hooks

### pre-commit

Runs PSScriptAnalyzer on all PowerShell files before allowing a commit. This ensures code quality standards are maintained.

**To bypass the hook** (not recommended):

```bash
git commit --no-verify
```

## For Contributors

All contributors should run the installation script after cloning the repository to ensure consistent code quality checks. Better yet, add it to your onboarding/bootstrap process.
