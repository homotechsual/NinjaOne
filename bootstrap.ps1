<#
.SYNOPSIS
	Bootstrap script for setting up the build environment in CI/CD pipelines.
.DESCRIPTION
	This script installs all required modules and dependencies for building the NinjaOne PowerShell module.
	It's designed to run in both Azure DevOps and GitHub Actions environments.
#>
[CmdletBinding()]
param(
	[Switch]$Force
)

$ErrorActionPreference = 'Stop'

Write-Host 'Bootstrap: Setting up build environment for NinjaOne module' -ForegroundColor Cyan

# Add bundled Modules directory to PSModulePath so bundled versions take precedence
$BundledModulesPath = Join-Path -Path $PSScriptRoot -ChildPath 'Modules'
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
	Install-Module -Name PowerShellGet -Force -Scope CurrentUser -AllowClobber
	Import-Module PowerShellGet -Force
}

# Install Install-RequiredModule script if not present
if (-not (Get-InstalledScript -Name 'Install-RequiredModule' -ErrorAction SilentlyContinue)) {
	Write-Host 'Bootstrap: Installing Install-RequiredModule script' -ForegroundColor Yellow
	Install-Script -Name 'Install-RequiredModule' -Force -Scope CurrentUser
}

# Install required modules from RequiredModules.psd1
$RequiredModulesPath = Join-Path -Path $PSScriptRoot -ChildPath 'RequiredModules.psd1'
if (Test-Path -Path $RequiredModulesPath) {
	Write-Host 'Bootstrap: Installing required modules from RequiredModules.psd1' -ForegroundColor Yellow
	
	# First, import bundled modules from the bundled path
	if (Test-Path -Path $BundledModulesPath) {
		Microsoft.PowerShell.Management\Get-ChildItem -LiteralPath $BundledModulesPath -Directory | ForEach-Object {
			$moduleDir = $_.FullName
			$manifestPath = Microsoft.PowerShell.Management\Get-ChildItem -LiteralPath $moduleDir -Filter '*.psd1' -Recurse | Select-Object -First 1
			if ($manifestPath) {
				Write-Host "Bootstrap: Loading bundled module version from: $($_.Name)" -ForegroundColor Green
				Import-Module -Path $manifestPath.FullName -Force -WarningAction SilentlyContinue
			}
		}
	}
	
	# Then install/update any missing modules
	Install-RequiredModule -RequiredModulesFile $RequiredModulesPath -Scope CurrentUser -TrustRegisteredRepositories -Import -Quiet
} else {
	throw "RequiredModules.psd1 not found at: $RequiredModulesPath"
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
