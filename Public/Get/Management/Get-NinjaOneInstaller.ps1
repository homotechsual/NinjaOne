
function Get-NinjaOneInstaller {
    <#
        .SYNOPSIS
            Gets agent installer URL from the NinjaOne API.
        .DESCRIPTION
            Retrieves agent installer URL from the NinjaOne v2 API.
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
        # Organisation ID
        [Parameter(Mandatory = $True)]
        [Alias('id', 'organizationId')]
        [Int]$organisationId,
        # Location ID
        [Parameter(Mandatory = $True)]
        [Int]$locationId,
        # Installer type/platform.
        [Parameter(Mandatory = $True)]
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
    if ($organisationID) {
        $Parameters.Remove('organisationID') | Out-Null
    }
    # Workaround to prevent the query string processor from adding a 'locationid=' parameter by removing it from the set parameters.
    if ($locationID) {
        $Parameters.Remove('locationID') | Out-Null
    }
    # Workaround to prevent the query string processor from adding an 'installertype=' parameter by removing it from the set parameters.
    if ($installerType) {
        $Parameters.Remove('installerType') | Out-Null
    }
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        if ($organisationID -and $locationID) {
            Write-Verbose 'Getting device from NinjaOne API.'
            $Organisation = Get-NinjaOneOrganisations -organisationID $organisationID
            $Location = Get-NinjaOneLocations -organisationID $organisationID | Where-Object { $_.id -eq $locationID }
            if ($Organisation -and $Location) {
                Write-Verbose "Retrieving installer for $($Organisation.Name) - $($Location.Name) `($installerType`)."
                $Resource = "v2/organization/$($organisationID)/location/$($locationID)/installer/$($installerType)"
            }
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