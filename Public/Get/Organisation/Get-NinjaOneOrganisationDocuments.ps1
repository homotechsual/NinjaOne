function Get-NinjaOneOrganisationDocuments {
    <#
        .SYNOPSIS
            Gets documents from the NinjaOne API.
        .DESCRIPTION
            Retrieves documents from the NinjaOne v2 API.
        .EXAMPLE
            Get-NinjaOneOrganisationDocuments -organisationId 1

            Gets documents for the organisation with id 1.
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
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        Write-Verbose 'Getting organisation documents from NinjaOne API.'
        $Organisation = Get-NinjaOneOrganisations -organisationId $organisationId
        if ($Organisation) {
            Write-Verbose "Retrieving organisation documents for $($Organisation.Name)."
            $Resource = "v2/organization/$($organisationId)/documents"
        }
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $ActivityResults = New-NinjaOneGETRequest @RequestParams
        Return $ActivityResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}