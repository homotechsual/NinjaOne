function New-NinjaOneInstaller {
    <#
        .SYNOPSIS
            Creates a new installer using the NinjaOne API.
        .DESCRIPTION
            Create a new installer download link using the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The organization ID to use when creating the installer.
        [Parameter(Mandatory)]
        [Alias('id', 'organizationId')]
        [Int]$organisationId,
        # The location ID to use when creating the installer.
        [Parameter(Mandatory)]
        [Int]$locationId,
        # The installer type to use when creating the installer.
        [Parameter(Mandatory)]
        [ValidateSet('WINDOWS_MSI', 'MAC_DMG', 'MAC_PKG', 'LINUX_DEB', 'LINUX_RPM')]
        [String]$installerType,
        # The number of uses permitted for the installer.
        [Int]$usageLimit
    )
    try {
        $Resource = 'v2/organization/generate-installer'
        $InstallerBody = @{
            organization_id = $organisationId
            location_id = $locationId
            installer_type = $installerType
            usage_limit = $usageLimit
            content = @{} 
        }
        $RequestParams = @{
            Resource = $Resource
            Body = $InstallerBody
        }
        $OrganisationExists = (Get-NinjaOneOrganisations -organisationId $organisationId).Count -gt 0
        $LocationExists = (Get-NinjaOneLocations -organisationId $organisationId | Where-Object { $_.id -eq $locationId }).Count -gt 0
        if ($OrganisationExists -and $LocationExists) {
            if ($PSCmdlet.ShouldProcess('Installer', 'Create')) {
                $InstallerCreate = New-NinjaOnePOSTRequest @RequestParams
                Return $InstallerCreate.url
            }
        } else {
            throw "Organisation '$organisationId' or location '$locationId' does not exist."
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}