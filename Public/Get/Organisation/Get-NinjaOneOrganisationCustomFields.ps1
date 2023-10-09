function Get-NinjaOneOrganisationCustomFields {
    <#
        .SYNOPSIS
            Gets organisation custom fields from the NinjaOne API.
        .DESCRIPTION
            Retrieves organisation custom fields from the NinjaOne v2 API.
        .EXAMPLE
            Get-NinjaOneOrganisationCustomFields -organisationId 1

            Gets custom field details for the organisation with id 1.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Filter by organisation ID.
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        [Alias('id', 'organizationId')]
        [Int]$organisationId
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        # Workaround to prevent the query string processor from adding an 'organisationid=' parameter by removing it from the set parameters.
        if ($organisationID) {
            $Parameters.Remove('organisationID') | Out-Null
        }
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        Write-Verbose 'Getting organisation custom fields from NinjaOne API.'
        $Organisation = Get-NinjaOneOrganisations -organisationId $organisationId
        if ($Organisation) {
            Write-Verbose "Retrieving custom fields for organisation $($Organisation.Name)."
            $Resource = "v2/organization/$($organisationId)/custom-fields"
        }
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $CustomFieldResults = New-NinjaOneGETRequest @RequestParams
        Return $CustomFieldResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}