
function Get-NinjaOneLocationBackupUsage {
    <#
        .SYNOPSIS
            Gets backup usage for a location from the NinjaOne API.
        .DESCRIPTION
            Retrieves backup usage for a location from the NinjaOne v2 API. For all locations omit the `locationId` parameter for devices backup usage use `Get-NinjaOneBackupUsage`.
        .FUNCTIONALITY
            Location Backup Usage
        .EXAMPLE
            PS> Get-NinjaOneLocationBackupUsage -organisationId 1

            Gets backup usage for all locations in the organisation with id 1.
        .EXAMPLE
            PS> Get-NinjaOneLocationBackupUsage -organisationId 1 -locationId 1

            Gets backup usage for the location with id 1 in the organisation with id 1.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/locationbackupusage
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Alias('gnolbu')]
    [MetadataAttribute(
        '/v2/organization/{id}/locations/backup/usage',
        'get',
        '/v2/organization/{id}/locations/{locationId}/backup/usage',
        'get'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Organisation id to retrieve backup usage for.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id', 'organizationId')]
        [Int]$organisationId,
        # Location id to retrieve backup usage for.
        [Parameter(Position = 1, ValueFromPipelineByPropertyName)]
        [Int]$locationId
    )
    process {
        try {
            Write-Verbose 'Getting organisation from NinjaOne API.'
            $Organisation = Get-NinjaOneOrganisations -organisationId $organisationId
            if ($Organisation) {
                Write-Verbose 'Getting location from NinjaOne API.'
                if ($locationId) {
                    $Location = Get-NinjaOneLocations -organisationId $organisationId | Where-Object -Property id -EQ -Value $locationId
                    if ($Location) {
                        Write-Verbose ('Getting backup usage for location {0} in organisation {1}.' -f $location.name, $organisation.name)
                        $Resource = ('v2/organization/{0}/locations/{1}/backup/usage' -f $organisationId, $locationId)
                    } else {
                        throw ('Location with id {0} not found in organisation {1}' -f $locationId, $Organisation.Name)
                    }
                } else {
                    $Locations = Get-NinjaOneLocations -organisationId $organisationId
                    if ($Organisation -and $Locations) {
                        Write-Verbose ('Getting backup usage for all locations in organisation {0}.' -f $organisation.name)
                        $Resource = ('v2/organization/{0}/locations/backup/usage' -f $organisationId)
                    } else {
                        throw ('Organisation {0} does not have any locations.' -f $Organisation.Name)
                    }
                }
            } else {
                throw ('Organisation with id {0} not found.' -f $organisationId)
            }
            $RequestParams = @{
                Resource = $Resource
            }
            $LocationBackupUsageResults = New-NinjaOneGETRequest @RequestParams
            return $LocationBackupUsageResults
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}