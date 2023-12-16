function Get-NinjaOneLocations {
    <#
        .SYNOPSIS
            Gets locations from the NinjaOne API.
        .DESCRIPTION
            Retrieves locations from the NinjaOne v2 API.
        .FUNCTIONALITY
            Locations
        .EXAMPLE
            PS> Get-NinjaOneLocations

            Gets all locations.
        .EXAMPLE
            PS> Get-NinjaOneLocations -after 1

            Gets all locations after location id 1.
        .EXAMPLE
            PS> Get-NinjaOneLocations -organisationId 1
            
            Gets all locations for the organisation with id 1.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/locations
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Alias('gnol')]
    [Metadata(
        '/v2/locations',
        'get',
        '/v2/organization/{id}/locations',
        'get'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Number of results per page.
        [Parameter(Position = 0)]
        [Int]$pageSize,
        # Start results from location id.
        [Parameter(Position = 1)]
        [Int]$after,
        # Filter by organisation id.
        [Parameter(Position = 2, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id', 'organizationId')]
        [Int]$organisationId
    )
    begin {
        $CommandName = $MyInvocation.InvocationName
        $Parameters = (Get-Command -Name $CommandName).Parameters
        # Workaround to prevent the query string processor from adding an 'organisationid=' parameter by removing it from the set parameters.
        if ($organisationId) {
            $Parameters.Remove('organisationId') | Out-Null
        }
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
    }
    process {
        try {
            if ($organisationId) {
                Write-Verbose 'Getting organisation from NinjaOne API.'
                $Organisation = Get-NinjaOneOrganisations -organisationId $organisationId
                if ($Organisation) {
                    Write-Verbose ('Getting locations for organisation {0}.' -f $Organisation.Name)
                    $Resource = ('v2/organization/{0}/locations' -f $organisationId)
                }
            } else {
                Write-Verbose 'Retrieving all locations.'
                $Resource = 'v2/locations'
            }
            $RequestParams = @{
                Resource = $Resource
                QSCollection = $QSCollection
            }
            $LocationResults = New-NinjaOneGETRequest @RequestParams
            if ($LocationResults) {
                return $LocationResults
            } else {
                throw ('No locations found for organisation {0}.' -f $Organisation.Name)
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}