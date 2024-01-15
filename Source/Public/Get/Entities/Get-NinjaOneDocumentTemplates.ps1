
function Get-NinjaOneDocumentTemplates {
    <#
        .SYNOPSIS
            Gets one or more document templates from the NinjaOne API.
        .DESCRIPTION
            Retrieves one or more document templates from the NinjaOne v2 API.
        .FUNCTIONALITY
            Document Template
        .OUTPUTS
            A powershell object containing the response.
        .EXAMPLE
            PS> Get-NinjaOneDocumentTemplate

            Retrieves all document templates with their fields.
        .EXAMPLE
            PS> Get-NinjaOneDocumentTemplate -documentTemplateId 1
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/documenttemplate
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Alias('gnodt', 'Get-NinjaOneDocumentTemplate')]
    [MetadataAttribute(
        '/v2/document-templates',
        'get',
        '/v2/document-templates/{documentTemplateId}',
        'get'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The document template id to retrieve.
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [String]$documentTemplateId
    )
    begin {
        $CommandName = $MyInvocation.InvocationName
        $Parameters = (Get-Command -Name $CommandName).Parameters
        # Workaround to prevent the query string processor from adding an 'documenttemplateid=' parameter by removing it from the set parameters.
        $Parameters.Remove('documentTemplateId') | Out-Null
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
    }
    process {
        try {
            if ($documentTemplateId) {
                Write-Verbose 'Getting document template from NinjaOne API.'
                $DocumentTemplate = Get-NinjaOneDocumentTemplates -documentTemplateId $documentTemplateId
                if ($DocumentTemplate) {
                    Write-Verbose ('Getting document template with id {0}.' -f $documentTemplateId)
                    $Resource = ('v2/document-templates/{0}' -f $documentTemplateId)
                }
            } else {
                Write-Verbose 'Retrieving all document templates.'
                $Resource = 'v2/document-templates'
            }
            $RequestParams = @{
                Resource = $Resource
                QSCollection = $QSCollection
            }
            try {
                $DocumentTemplateResults = New-NinjaOneGETRequest @RequestParams
                return $DocumentTemplateResults
            } catch {
                if (-not $DocumentTemplateResults) {
                    if ($documentTemplateId) {
                        throw ('Document template with id {0} not found.' -f $documentTemplateId)
                    } else {
                        throw 'No document templates found.'
                    }
                }
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}