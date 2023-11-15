function Set-NinjaOneOrganisationDocument {
    <#
        .SYNOPSIS
            Sets an organisation document.
        .DESCRIPTION
            Sets organisation documents using the NinjaOne v2 API.
        .FUNCTIONALITY
            Document
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The organisation to set the information for.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id', 'organizationId')]
        [Int]$organisationId,
        # The organisation document id to update.
        [Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
        [Int]$documentId,
        # The organisation information body object.
        [Parameter(Mandatory, Position = 2, ValueFromPipelineByPropertyName)]
        [Alias('organizationDocument', 'body')]
        [Object]$organisationDocument
    )
    if ($Script:NRAPIConnectionInformation.AuthMode -eq 'Client Credentials') {
        throw ('This function is not available when using client_credentials authentication. If this is unexpected please report this to api@ninjarmm.com.')
        exit 1
    }
    try {
        $Organisation = Get-NinjaOneOrganisations -OrganisationId $organisationId
        if ($Organisation) {
            Write-Verbose ('Getting organisation document {0} from NinjaOne API.' -f $documentId)
            $Document = Get-NinjaOneOrganisationDocuments -OrganisationId $organisationId | Where-Object { $_.id -eq $documentId }
            if ($Document) {
                Write-Verbose ('Setting organisation custom fields for organisation {0}.' -f $Organisation.Name)
                $Resource = ('v2/organization/{0}/document/{1}' -f $organisationId, $documentId)
            } else {
                throw ('Organisation document with id {0} not found in organisation {1}' -f $documentId, $Organisation.Name)
            }
        } else {
            throw ('Organisation with id {0} not found.' -f $organisationId)
        }
        $RequestParams = @{
            Resource = $Resource
            Body = $organisationDocument
        }
        if ($PSCmdlet.ShouldProcess(('Organisation {0} document {1}' -f $Organisation.Name, $Document.Name), 'Update')) {
            $OrganisationDocumentUpdate = New-NinjaOnePOSTRequest @RequestParams
            if ($OrganisationDocumentUpdate -eq 204) {
                $OIP = $InformationPreference
                $InformationPreference = 'Continue'
                Write-Information ('Organisation {0} document {1} updated successfully.' -f $Organisation.Name, $Document.Name)
                $InformationPreference = $OIP
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}