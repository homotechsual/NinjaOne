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

            Gets all locations after location Id 1.
        .EXAMPLE
            PS> Get-NinjaOneLocations -organisationId 1
            
            Gets all locations for the organisation with id 1.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Number of results per page.
        [Int]$pageSize,
        # Start results from location Id.
        [Int]$after,
        # Filter by organisation Id.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('id', 'organizationId')]
        [Int]$organisationId
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'organisationid=' parameter by removing it from the set parameters.
    if ($organisationId) {
        $Parameters.Remove('organisationId') | Out-Null
    }
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        if ($organisationId) {
            Write-Verbose 'Getting organisation from NinjaOne API.'
            $Organisation = Get-NinjaOneOrganisations -organisationId $organisationId
            if ($Organisation) {
                Write-Verbose "Retrieving locations for $($Organisation.Name)."
                $Resource = "v2/organization/$($organisationId)/locations"
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
        Return $LocationResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}