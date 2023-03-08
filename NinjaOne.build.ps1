<#
    .SYNOPSIS
        Homotechsual portable module build script.
#>
Param (
    [String]$Configuration = 'Development',
    [Switch]$UpdateHelp,
    [Switch]$CopyModuleFiles,
    [Switch]$Test,
    [Switch]$UpdateManifest,
    [Switch]$PublishModule,
    [Switch]$Clean
)

$ModuleName = 'NinjaOne'

# Use strict mode when building.
Set-StrictMode -Version Latest

# Update the PowerShell Module Help Files.
# Pre-requisites: PowerShell Module PlatyPS.

if ($UpdateHelp) {
    Import-Module -Name $ModuleName -Force
    Update-MarkdownHelp -Path "$($PSScriptRoot)\Docs\Markdown"
    New-ExternalHelp -Path "$($PSScriptRoot)\Docs\Markdown" -OutputPath "$($PSScriptRoot)\Docs\en_GB" -Force
}

# Copy PowerShell Module files to output folder for release on PSGallery
if ($CopyModuleFiles) {
    # Copy Module Files to Output Folder
    if (-not (Test-Path "$($PSScriptRoot)\Output\$ModuleName")) {
        New-Item -Path "$($PSScriptRoot)\Output\$ModuleName" -ItemType Directory | Out-Null
    }
    if (Test-Path -Path "$($PSScriptRoot)\Classes\") {
        Copy-Item -Path "$($PSScriptRoot)\Classes\" -Filter *.* -Recurse -Destination "$($PSScriptRoot)\Output\$ModuleName" -Force
    }
    if (Test-Path -Path "$($PSScriptRoot)\Data\") {
        Copy-Item -Path "$($PSScriptRoot)\Data\" -Filter *.* -Recurse -Destination "$($PSScriptRoot)\Output\$ModuleName" -Force
    }
    Copy-Item -Path "$($PSScriptRoot)\Private\" -Filter *.* -Recurse -Destination "$($PSScriptRoot)\Output\$ModuleName" -Force
    Copy-Item -Path "$($PSScriptRoot)\Public\" -Filter *.* -Recurse -Destination "$($PSScriptRoot)\Output\$ModuleName" -Force

    # Copy module, manifest and scaffold files
    Copy-Item -Path @(
        "$($PSScriptRoot)\LICENSE.md"
        "$($PSScriptRoot)\CHANGELOG.md"
        "$($PSScriptRoot)\README.md"
        "$($PSScriptRoot)\$ModuleName.psd1"
        "$($PSScriptRoot)\$ModuleName.psm1"
    ) -Destination "$($PSScriptRoot)\Output\$ModuleName" -Force
}

# Run all Pester tests in folder .\Tests
if ($Test) {
    $Result = Invoke-Pester "$($PSScriptRoot)\Tests" -PassThru
    if ($Result.FailedCount -gt 0) {
        throw 'Pester tests failed'
    }
}

# Update the Module Manifest file with info from the Changelog.
if ($UpdateManifest) {
    # Import PlatyPS. Needed for parsing the versions in the Changelog.
    Import-Module -Name PlatyPS

    # Find Latest Version in Change log.
    $CHANGELOG = Get-Content -Path "$($PSScriptRoot)\CHANGELOG.md"
    $MarkdownObject = [Markdown.MAML.Parser.MarkdownParser]::new()
    [regex]$Regex = '\d\.\d\.\d'
    $Versions = $Regex.Matches($MarkdownObject.ParseString($CHANGELOG).Children.Spans.Text) | ForEach-Object { $_.Value }
    $ChangeLogVersion = ($Versions | Measure-Object -Maximum).Maximum

    $ManifestPath = "$($PSScriptRoot)\$ModuleName.psd1"

    # Start by importing the manifest to determine the version, then add 1 to the Build
    $Manifest = Test-ModuleManifest -Path $ManifestPath
    [System.Version]$Version = $Manifest.Version

    if ($ChangeLogVersion -eq $Version) {
        Throw 'No new version found in CHANGELOG.md'
    }

    Write-Output -InputObject ("Current Module Version: $($Version)")
    Write-Output -InputObject ("New Module version: $($ChangeLogVersion)")

    # Update Manifest file with Release Notes
    $CHANGELOG = Get-Content -Path "$($PSScriptRoot)\CHANGELOG.md"
    $MarkdownObject = [Markdown.MAML.Parser.MarkdownParser]::new()
    $ReleaseNotes = ((($MarkdownObject.ParseString($CHANGELOG).Children.Spans.Text) -Match '\d\.\d\.\d') -Split ' - ')[1]

    # Update Module with new version
    Update-ModuleManifest -ModuleVersion $ChangeLogVersion -Path "$($PSScriptRoot)\$ModuleName.psd1" -ReleaseNotes $ReleaseNotes
}

# Publish Module to PowerShell Gallery
if ($PublishModule -and $Configuration -eq 'Production') {
    Try {
        # Build a splat containing the required details and make sure to Stop for errors which will trigger the catch
        $params = @{
            Path = ("$($PSScriptRoot)\Output\$ModuleName")
            NuGetApiKey = $ENV:TF_BUILD ? $ENV:PSGalleryAPIKey : (Get-AzKeyVaultSecret -VaultName $ENV:PSGalleryVault -Name $ENV:PSGallerySecret -AsPlainText) # If running in Azure DevOps, use the Environment Variable, otherwise use the Key Vault
            ErrorAction = 'Stop'
        }
        $ManifestPath = "$($PSScriptRoot)\$ModuleName.psd1"
        $Manifest = Test-ModuleManifest -Path $ManifestPath
        [System.Version]$Version = $Manifest.Version
        Publish-Module @params
        Write-Output -InputObject ("$ModuleName PowerShell Module version $($Version) published to the PowerShell Gallery")
    } Catch {
        Throw $_
    }
}

# Clean up Output folder
if ($Clean) {
    # Clean output folder
    if ((Test-Path "$($PSScriptRoot)\Output")) {
        Remove-Item -Path "$($PSScriptRoot)\Output" -Recurse -Force
    }
}