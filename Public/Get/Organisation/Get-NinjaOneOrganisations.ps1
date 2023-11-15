function Get-NinjaOneOrganisations {
    <#
        .SYNOPSIS
            Gets organisations from the NinjaOne API.
        .DESCRIPTION
            Retrieves organisations from the NinjaOne v2 API.
        .FUNCTIONALITY
            Organisations
        .EXAMPLE
            PS> Get-NinjaOneOrganisations

            Gets all organisations.
        .EXAMPLE
            PS> Get-NinjaOneOrganisations -organisationId 1

            Gets the organisation with id 1.
        .EXAMPLE
            PS> Get-NinjaOneOrganisations -pageSize 10 -after 1

            Gets 10 organisations starting from organisation id 1.
        .EXAMPLE
            PS> Get-NinjaOneOrganisations -detailed

            Gets all organisations with locations and policy mappings.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( DefaultParameterSetName = 'Multi' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Organisation id
        [Parameter(ParameterSetName = 'Single', Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id', 'organizationId')]
        [Int]$organisationId,
        # Number of results per page.
        [Parameter(ParameterSetName = 'Multi', Position = 1)]
        [Int]$pageSize,
        # Start results from organisation id.
        [Parameter(ParameterSetName = 'Multi', Position = 2)]
        [Int]$after,
        # Include locations and policy mappings.
        [Parameter(ParameterSetName = 'Multi', Position = 3)]
        [Switch]$detailed
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'organisationid=' parameter by removing it from the set parameters.
    if ($organisationId) {
        $Parameters.Remove('organisationId') | Out-Null
    }
    # Similarly we don't want a `detailed=true` parameter since we're targetting a different resource.
    if ($detailed) {
        $Parameters.Remove('detailed') | Out-Null
    }
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        if ($organisationId) {
            Write-Verbose ('Getting organisation with id {0}.' -f $organisationId)
            $Resource = ('v2/organization/{0}' -f $organisationId)
            $RequestParams = @{
                Resource = $Resource
                QSCollection = $QSCollection
            }
        } else {
            if ($detailed) {
                Write-Verbose 'Retrieving detailed information on all organisations'
                $Resource = 'v2/organizations-detailed'
            } else {
                Write-Verbose 'Retrieving all organisations'
                $Resource = 'v2/organizations'
            }
            $RequestParams = @{
                Resource = $Resource
                QSCollection = $QSCollection
            }
        }
        try {
            $OrganisationResults = New-NinjaOneGETRequest @RequestParams
            return $OrganisationResults
        } catch {
            if (-not $OrganisationResults) {
                if ($organisationId) {
                    throw ('Organisation with id {0} not found.' -f $organisationId)
                } else {
                    throw 'No organisations found.'
                }
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}