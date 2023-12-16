
function Get-NinjaOneInstaller {
    <#
        .SYNOPSIS
            Gets agent installer URL from the NinjaOne API.
        .DESCRIPTION
            Retrieves agent installer URL from the NinjaOne v2 API.
        .FUNCTIONALITY
            Installer
        .EXAMPLE
            PS> Get-NinjaOneInstaller -organisationId 1 -locationId 1 -installerType WINDOWS_MSI

            Gets the agent installer URL for the location with id 1 in the organisation with id 1 for the Windows MSI installer.
        .EXAMPLE
            PS> Get-NinjaOneInstaller -organisationId 1 -locationId 1 -installerType MAC_PKG

            Gets the agent installer URL for the location with id 1 in the organisation with id 1 for the Mac PKG installer.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/installer
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Alias('gnoi')]
    [Metadata(
        '/v2/organization/{id}/location/{location_id}/installer/{installer_type}',
        'get'
    )]
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
    begin {
        $CommandName = $MyInvocation.InvocationName
        $Parameters = (Get-Command -Name $CommandName).Parameters
        # Workaround to prevent the query string processor from adding an 'organisationid=' parameter by removing it from the set parameters.
        $Parameters.Remove('organisationId') | Out-Null
        # Workaround to prevent the query string processor from adding a 'locationid=' parameter by removing it from the set parameters.
        $Parameters.Remove('locationId') | Out-Null
        # Workaround to prevent the query string processor from adding an 'installertype=' parameter by removing it from the set parameters.
        $Parameters.Remove('installerType') | Out-Null
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
    }
    process {
        try {
            Write-Verbose 'Getting device from NinjaOne API.'
            $Organisation = Get-NinjaOneOrganisations -organisationId $organisationId
            $Location = Get-NinjaOneLocations -organisationId $organisationId | Where-Object { $_.id -eq $locationId }
            if ($Organisation -and $Location) {
                Write-Verbose ('Getting installer for organisation {0} - location {1} ({2}).' -f $Organisation.Name, $Location.Name, $installerType)
                $Resource = ('v2/organization/{0}/location/{1}/installer/{2}' -f $organisationId, $locationId, $installerType)
            }
            $RequestParams = @{
                Resource = $Resource
                QSCollection = $QSCollection
            }
            $AgentInstallerResults = New-NinjaOneGETRequest @RequestParams
            if ($AgentInstallerResults) {
                return $AgentInstallerResults
            } else {
                throw ('No agent installer found for organisation { 0 } - location { 1 } ({ 2 }).' -f $Organisation.Name, $Location.Name, $installerType)
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}