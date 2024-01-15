function Remove-NinjaOneDocumentTemplate {
    <#
        .SYNOPSIS
            Removes a document template using the NinjaOne API.
        .DESCRIPTION
            Removes the specified document template NinjaOne v2 API.
        .FUNCTIONALITY
            Document Template
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/documenttemplate
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([Object])]
    [Alias('rnodt')]
    [MetadataAttribute(
        '/v2/document-templates/{documentTemplateId}',
        'delete'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The document template to delete.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [Int]$documentTemplateId
    )
    process {
        try {
            $DocumentTemplate = Get-NinjaOneDocumentTemplates -documentTemplateId $documentTemplateId
            if ($DocumentTemplate) {
                $Resource = ('v2/document-templates/{0}' -f $documentTemplateId)
            } else {
                throw ('Document template with id {0} not found.' -f $documentTemplateId)
            }
            $RequestParams = @{
                Resource = $Resource
            }
            if ($PSCmdlet.ShouldProcess(('Document Template {0}' -f $DocumentTemplate.Name), 'Delete')) {
                $DocumentTemplateDelete = New-NinjaOneDELETERequest @RequestParams
                if ($DocumentTemplateDelete -eq 204) {
                    Write-Information ('Document template {0} deleted successfully.' -f $DocumentTemplate.Name)
                }
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}