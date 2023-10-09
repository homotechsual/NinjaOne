
function Get-NinjaOneLocationBackupUsage {
    <#
        .SYNOPSIS
            Gets backup usage for a location from the NinjaOne API.
        .DESCRIPTION
            Retrieves backup usage for a location from the NinjaOne v2 API. For all locations omit the `locationId` parameter for devices backup usage use `Get-NinjaOneBackupUsage`.
        .EXAMPLE
            PS> Get-NinjaOneLocationBackupUsage -organisationId 1

            Gets backup usage for all locations in the organisation with id 1.
        .EXAMPLE
            PS> Get-NinjaOneLocationBackupUsage -organisationId 1 -locationId 1

            Gets backup usage for the location with id 1 in the organisation with id 1.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Organisation ID
        [Parameter(ValueFromPipelineByPropertyName, Mandatory, Position = 0)]
        [Alias('id', 'organizationId')]
        [Int]$organisationId,
        # Location ID
        [Parameter(ValueFromPipelineByPropertyName, Position = 1)]
        [Alias('id')]
        [Int]$locationId
    )
    try {
        Write-Verbose 'Getting organisation from NinjaOne API.'
        $Organisation = Get-NinjaOneOrganisations -organisationId $organisationId
        Write-Verbose 'Getting location from NinjaOne API.'
        if ($locationId) {
            $Location = Get-NinjaOneLocations -organisationId $organisationId -locationId $locationId
            if ($Organisation -and $Location) {
                Write-Verbose "Retrieving backup usage for $($Location.Name)."
                $Resource = "v2/organization/$($organisationId)/locations/$($locationId)/backup/usage"
            }
        } else {
            $Location = Get-NinjaOneLocations -organisationId $organisationId
            if ($Organisation -and $Location) {
                Write-Verbose "Retrieving backup usage for all locations for $($Organisation.Name)."
                $Resource = "v2/organization/$($organisationId)/locations/backup/usage"
            }
        }
        $RequestParams = @{
            Resource = $Resource
        }
        $LocationBackupUsageResults = New-NinjaOneGETRequest @RequestParams
        Return $LocationBackupUsageResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}