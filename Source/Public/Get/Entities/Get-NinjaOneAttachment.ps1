
function Get-NinjaOneAttachment {
    <#
        .SYNOPSIS
            Gets a help request form / systray help form attachment from the NinjaOne API.
        .DESCRIPTION
            Retrieves a help request form / systray help form attachment from the NinjaOne v2 API.
        .FUNCTIONALITY
            Attachment
        .OUTPUTS
            A powershell object containing the response.
        .EXAMPLE
            PS> Get-NinjaOneAttachment -attachmentId 'somethinggoesherebutidontknowwhatandneitherdoninja'

            Retrieves the attachment with id 'somethinggoesherebutidontknowwhatandneitherdoninja'.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/attachment
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Alias('gnoat')]
    [MetadataAttribute(
        '/v2/attachment/{id}',
        'get'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The attachment id to retrieve.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [String]$attachmentId
    )
    begin {
        $CommandName = $MyInvocation.InvocationName
        $Parameters = (Get-Command -Name $CommandName).Parameters
        # Workaround to prevent the query string processor from adding an 'attachmentid=' parameter by removing it from the set parameters.
        $Parameters.Remove('attachmentId') | Out-Null
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
    }
    process {
        try {
            Write-Verbose 'Retrieving attachment.'
            $Resource = ('v2/attachment/{0}' -f $attachmentId)
            $RequestParams = @{
                Resource = $Resource
                QSCollection = $QSCollection
            }
            $AttachmentResults = New-NinjaOneGETRequest @RequestParams
            if ($AttachmentResults) {
                return $AttachmentResults   
            } else {
                throw ('Attachment with id {0} not found.' -f $attachmentId)
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}