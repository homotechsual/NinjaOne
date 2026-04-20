<#
.SYNOPSIS
	Bootstrap script for setting up the build environment in CI/CD pipelines.
.DESCRIPTION
	This script installs all required modules and dependencies for building the NinjaOne PowerShell module.
	It's designed to run in both Azure DevOps and GitHub Actions environments.
#>
[CmdletBinding()]
param(
	[Switch]$force
)

$BuildToolsRoot = $PSScriptRoot
$RepoRoot = Resolve-Path -Path (Join-Path -Path $BuildToolsRoot -ChildPath '..\\..')

$ErrorActionPreference = 'Stop'

Write-Host 'Bootstrap: Setting up build environment for NinjaOne module' -ForegroundColor Cyan

# Add bundled Modules directory to PSModulePath so bundled versions take precedence
$BundledModulesPath = Join-Path -Path $RepoRoot -ChildPath 'Modules'
if (Test-Path -Path $BundledModulesPath) {
	Write-Host 'Bootstrap: Adding bundled modules to PSModulePath' -ForegroundColor Cyan
	$env:PSModulePath = "$BundledModulesPath;$($env:PSModulePath)"
	Write-Host "Bootstrap: PSModulePath updated to prioritize: $BundledModulesPath" -ForegroundColor Cyan
}

# Ensure we're using TLS 1.2 for downloads
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Install PowerShellGet if needed (for older systems)
if (-not (Get-Module -Name PowerShellGet -ListAvailable).Where({ $_.Version -ge '2.0.0' })) {
	Write-Host 'Bootstrap: Installing PowerShellGet' -ForegroundColor Yellow
	Install-Module -Name PowerShellGet -force -Scope CurrentUser -AllowClobber
	Import-Module PowerShellGet -force
}

# Install Install-RequiredModule script if not present
if (-not (Get-InstalledScript -Name 'Install-RequiredModule' -ErrorAction SilentlyContinue)) {
	Write-Host 'Bootstrap: Installing Install-RequiredModule script' -ForegroundColor Yellow
	Install-Script -Name 'Install-RequiredModule' -force -Scope CurrentUser
}

$installCmd = Get-Command -Name 'Install-RequiredModule' -ErrorAction SilentlyContinue
if (-not $installCmd) {
	$installedScript = Get-InstalledScript -Name 'Install-RequiredModule' -ErrorAction SilentlyContinue
	if ($installedScript) {
		$installCmdPath = Join-Path -Path $installedScript.InstalledLocation -ChildPath 'Install-RequiredModule.ps1'
	}
} else {
	if ($installCmd.Path) {
		$installCmdPath = $installCmd.Path
	} elseif ($installCmd.Source -and (Test-Path -Path $installCmd.Source)) {
		$installCmdPath = $installCmd.Source
	}
}

if (-not $installCmdPath) {
	$userDocs = [Environment]::GetFolderPath('MyDocuments')
	$fallbackPaths = @(
		(Join-Path -Path $userDocs -ChildPath 'PowerShell\Scripts\Install-RequiredModule.ps1'),
		(Join-Path -Path $userDocs -ChildPath 'WindowsPowerShell\Scripts\Install-RequiredModule.ps1')
	)
	$installCmdPath = $fallbackPaths | Where-Object { Test-Path -Path $_ } | Select-Object -First 1
}

if (-not $installCmdPath) {
	throw 'Install-RequiredModule script not found. Ensure it is installed and available to the current user.'
}

# Install required modules from RequiredModules.psd1
$RequiredModulesPath = Join-Path -Path $BuildToolsRoot -ChildPath 'RequiredModules.psd1'
if (Test-Path -Path $RequiredModulesPath) {
	Write-Host 'Bootstrap: Installing required modules from RequiredModules.psd1' -ForegroundColor Yellow
	
	# First, import bundled modules from the bundled path
	if (Test-Path -Path $BundledModulesPath) {
		Microsoft.PowerShell.Management\Get-ChildItem -LiteralPath $BundledModulesPath -Directory | ForEach-Object {
			$moduleDir = $_.FullName
			$manifestPath = Microsoft.PowerShell.Management\Get-ChildItem -LiteralPath $moduleDir -Filter '*.psd1' -Recurse | Select-Object -First 1
			if ($manifestPath) {
				Write-Host "Bootstrap: Loading bundled module version from: $($_.Name)" -ForegroundColor Green
				Import-Module -Name $manifestPath.FullName -force -WarningAction SilentlyContinue
			}
		}
	}
	
	# Then install/update any missing modules
	& $installCmdPath -RequiredModulesFile $RequiredModulesPath -Scope CurrentUser -TrustRegisteredRepositories -Import -Quiet
} else {
	throw "RequiredModules.psd1 not found at: $RequiredModulesPath"
}

# Configure Git hooks (like Husky)
if (Test-Path (Join-Path $RepoRoot '.git')) {
	Write-Host 'Bootstrap: Configuring Git hooks...' -ForegroundColor Cyan
	try {
		git -C $RepoRoot config core.hooksPath 'DevOps/hooks' 2>$null
		if ($LASTEXITCODE -eq 0) {
			Write-Host '  ✓ Git hooks configured (PSScriptAnalyzer will run pre-commit)' -ForegroundColor Green
		}
	} catch {
		Write-Host '  ⚠ Could not configure Git hooks (git not available or not a repository)' -ForegroundColor Yellow
	}
}

Write-Host 'Bootstrap: Environment setup complete!' -ForegroundColor Green
Write-Host 'Bootstrap: The following modules are now available:' -ForegroundColor Cyan
$RequiredModules = Import-PowerShellDataFile -Path $RequiredModulesPath
$RequiredModules.GetEnumerator() | ForEach-Object {
	$Module = Get-Module -Name $_.Key -ListAvailable | Select-Object -First 1
	if ($Module) {
		Write-Host "  ✓ $($_.Key) v$($Module.Version)" -ForegroundColor Green
	} else {
		Write-Host "  ✗ $($_.Key) - NOT FOUND" -ForegroundColor Red
	}
}
