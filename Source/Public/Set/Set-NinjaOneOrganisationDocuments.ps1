function Set-NinjaOneOrganisationDocuments {
    <#
        .SYNOPSIS
            Sets one or more organisation documents.
        .DESCRIPTION
            Sets one or more organisation documents using the NinjaOne v2 API.
        .FUNCTIONALITY
            Organisation Documents
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/organisationdocument
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([Object])]
    [Alias('snoods', 'Set-NinjaOneOrganizationDocuments', 'unoods', 'Update-NinjaOneOrganisationDocuments', 'Update-NinjaOneOrganizationDocuments')]
    [MetadataAttribute(
        '/v2/organization/documents',
        'patch'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The organisation documents to update.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('organizationDocuments', 'body')]
        [NinjaOneOrganisationDocument[]]$organisationDocuments
    )
    begin {
        if ($Script:NRAPIConnectionInformation.AuthMode -eq 'Client Credentials') {
            throw ('This function is not available when using client_credentials authentication. If this is unexpected please report this to api@ninjarmm.com.')
            exit 1
        }
    }
    process {
        try {
            foreach ($Document in $organisationDocuments) {
                Write-Verbose ('Getting organisation document {0} from NinjaOne API.' -f $Document.documentId)
                $Document = Get-NinjaOneOrganisationDocuments -OrganisationId $organisationId | Where-Object { $_.documentId -eq $documentId }
                if (-not $Document) {
                    throw ('Organisation document with id {0} not found in organisation {1}' -f $documentId, $Organisation.Name)
                    $Resource = ('v2/organization/documents' -f $organisationId, $documentId)
                    $RequestParams = @{
                        Resource = $Resource
                        Body = $organisationDocuments
                    }
                }
                if ($PSCmdlet.ShouldProcess(('Organisation {0} documents {1}' -f $organisationDocuments.organizationId, $organisationDocuments.documentId), 'Update')) {
                    $OrganisationDocumentsUpdate = New-NinjaOnePATCHRequest @RequestParams
                    if ($OrganisationDocumentsUpdate -eq 204) {
                        Write-Information ('Organisation documents updated successfully.')
                    } else {
                        return $OrganisationDocumentsUpdate
                    }
                }
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}