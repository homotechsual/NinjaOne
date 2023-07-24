function Update-NinjaOneOrganisationDocument {
    <#
        .SYNOPSIS
            Updates an organisation document.
        .DESCRIPTION
            Updates organisation documents using the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The organisation to set the information for.
        [Parameter(Mandatory = $true)]
        [int]$organisationId,
        # The organisation document id to update.
        [Parameter(Mandatory = $true)]
        [int]$documentId,
        # The organisation information body object.
        [Parameter(Mandatory = $true)]
        [object]$organisationDocument
    )
    if ($Script:NRAPIConnectionInformation.AuthMode -eq 'Client Credentials') {
        throw ('This function is not available when using client_credentials authentication. If this is unexpected please report this to api@ninjarmm.com.')
        exit 1
    }
    try {
        $Resource = "v2/organization/$organisationId/document/$documentId"
        $RequestParams = @{
            Resource = $Resource
            Body = $organisationDocument
        }
        $OrganisationExists = (Get-NinjaOneOrganisations -OrganisationId $organisationId).Count -gt 0
        $DocumentExists = (Get-NinjaOneOrganisationDocuments -OrganisationId $organisationId).documentId -contains $documentId
        if ($OrganisationExists) {
            if ($DocumentExists) {
                if ($PSCmdlet.ShouldProcess('Organisation document', 'Update')) {
                    $OrganisationDocumentUpdate = New-NinjaOnePOSTRequest @RequestParams
                    if ($OrganisationDocumentUpdate -eq 204) {
                        Write-Information "Organisation document id $($documentId) for organisation $($organisationId) updated successfully."
                    }
                }
            } else {
                Throw "Organisation document id $($documentId) does not exist."
            }
            
        } else {
            Throw "Organisation $($organisationId) does not exist."
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}