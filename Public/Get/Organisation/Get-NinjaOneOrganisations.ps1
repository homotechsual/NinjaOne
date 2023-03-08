function Get-NinjaOneOrganisations {
    <#
        .SYNOPSIS
            Gets organisations from the NinjaOne API.
        .DESCRIPTION
            Retrieves organisations from the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( DefaultParameterSetName = 'Multi' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Organisation ID
        [Parameter( ParameterSetName = 'Single', Mandatory = $True )]
        [Alias('organizationId')]
        [Int]$organisationId,
        # Number of results per page.
        [Parameter( ParameterSetName = 'Multi' )]
        [Int]$pageSize,
        # Start results from organisation ID.
        [Parameter( ParameterSetName = 'Multi' )]
        [Int]$after,
        # Include locations and policy mappings.
        [Parameter( ParameterSetName = 'Multi')]
        [Switch]$detailed
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'organisationid=' parameter by removing it from the set parameters.
    if ($organisationID) {
        $Parameters.Remove('organisationID') | Out-Null
    }
    # Similarly we don't want a `detailed=true` parameter since we're targetting a different resource.
    if ($detailed) {
        $Parameters.Remove('detailed') | Out-Null
    }
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        if ($organisationID) {
            Write-Verbose "Retrieving information on organisation with ID $($organisationID)"
            $Resource = "v2/organization/$($organisationID)"
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
        $OrganisationResults = New-NinjaOneGETRequest @RequestParams
        Return $OrganisationResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}