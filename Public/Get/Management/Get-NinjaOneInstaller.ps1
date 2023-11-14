
function Get-NinjaOneInstaller {
    <#
        .SYNOPSIS
            Gets agent installer URL from the NinjaOne API.
        .DESCRIPTION
            Retrieves agent installer URL from the NinjaOne v2 API.
        .FUNCTIONALITY
            Installer
        .EXAMPLE
            PS> Get-NinjaOneInstaller -organisationID 1 -locationID 1 -installerType WINDOWS_MSI

            Gets the agent installer URL for the location with id 1 in the organisation with id 1 for the Windows MSI installer.
        .EXAMPLE
            PS> Get-NinjaOneInstaller -organisationID 1 -locationID 1 -installerType MAC_PKG

            Gets the agent installer URL for the location with id 1 in the organisation with id 1 for the Mac PKG installer.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The organisation id to get the installer for.
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [Alias('id', 'organizationId')]
        [Int]$organisationId,
        # The location id to get the installer for.
        [Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
        [Int]$locationId,
        # Installer type/platform.
        [Parameter(Mandatory, Position = 2, ValueFromPipelineByPropertyName)]
        [ValidateSet(
            'WINDOWS_MSI',
            'MAC_DMG',
            'MAC_PKG',
            'LINUX_DEB',
            'LINUX_RPM'
        )]
        [String]$installerType
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'organisationid=' parameter by removing it from the set parameters.
    $Parameters.Remove('organisationId') | Out-Null
    # Workaround to prevent the query string processor from adding a 'locationid=' parameter by removing it from the set parameters.
    $Parameters.Remove('locationId') | Out-Null
    # Workaround to prevent the query string processor from adding an 'installertype=' parameter by removing it from the set parameters.
    $Parameters.Remove('installerType') | Out-Null
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        Write-Verbose 'Getting device from NinjaOne API.'
        $Organisation = Get-NinjaOneOrganisations -organisationId $organisationId
        $Location = Get-NinjaOneLocations -organisationId $organisationId | Where-Object { $_.id -eq $locationId }
        if ($Organisation -and $Location) {
            Write-Verbose "Retrieving installer for $($Organisation.Name) - $($Location.Name) `($installerType`)."
            $Resource = "v2/organization/$($organisationId)/location/$($locationId)/installer/$($installerType)"
        }
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $AgentInstallerResults = New-NinjaOneGETRequest @RequestParams
        Return $AgentInstallerResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}