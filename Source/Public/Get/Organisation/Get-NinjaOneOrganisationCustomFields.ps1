function Get-NinjaOneOrganisationCustomFields {
    <#
        .SYNOPSIS
            Gets organisation custom fields from the NinjaOne API.
        .DESCRIPTION
            Retrieves organisation custom fields from the NinjaOne v2 API.
        .FUNCTIONALITY
            Organisation Custom Fields
        .EXAMPLE
            Get-NinjaOneOrganisationCustomFields -organisationId 1

            Gets custom field details for the organisation with id 1.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationcustomfields
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Alias('gnoocf', 'Get-NinjaOneOrganizationCustomFields')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Filter by organisation id.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
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
            Write-Verbose 'Getting organisation custom fields from NinjaOne API.'
            $Organisation = Get-NinjaOneOrganisations -organisationId $organisationId
            if ($Organisation) {
                Write-Verbose ('Getting custom fields for organisation {0}.' -f $Organisation.Name)
                $Resource = ('v2/organization/{0}/custom-fields' -f $organisationId)
            } else {
                throw ('Organisation with id {0} not found.' -f $organisationId)
            }
            $RequestParams = @{
                Resource = $Resource
                QSCollection = $QSCollection
            }
            $CustomFieldResults = New-NinjaOneGETRequest @RequestParams
            if ($CustomFieldResults) {
                return $CustomFieldResults
            } else {
                throw ('No custom fields found for organisation {0}.' -f $Organisation.Name)
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}