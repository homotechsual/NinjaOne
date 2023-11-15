function New-NinjaOneInstaller {
    <#
        .SYNOPSIS
            Creates a new installer using the NinjaOne API.
        .DESCRIPTION
            Create a new installer download link using the NinjaOne v2 API.
        .FUNCTIONALITY
            Create Installer
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The organization id to use when creating the installer.
        [Parameter(Mandatory, Position = 0)]
        [Alias('id', 'organizationId')]
        [Int]$organisationId,
        # The location id to use when creating the installer.
        [Parameter(Mandatory, Position = 1)]
        [Int]$locationId,
        # The installer type to use when creating the installer.
        [Parameter(Mandatory, Position = 2)]
        [ValidateSet('WINDOWS_MSI', 'MAC_DMG', 'MAC_PKG', 'LINUX_DEB', 'LINUX_RPM')]
        [String]$installerType,
        # The number of uses permitted for the installer.
        [Parameter(Position = 3)]
        [Int]$usageLimit,
        # The node role id to use when creating the installer.
        [Parameter(Position = 4)]
        [ValidateNodeRoleId()]
        [Object]$nodeRoleId = 'auto'
    )
    try {
        $Resource = 'v2/organization/generate-installer'
        $InstallerBody = @{
            organization_id = $organisationId
            location_id = $locationId
            installer_type = $installerType
            usage_limit = $usageLimit
            content = @{
                nodeRoleId = $nodeRoleId
            }
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
                return $InstallerCreate.url
            }
        } else {
            throw "Organisation '$organisationId' or location '$locationId' does not exist."
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}