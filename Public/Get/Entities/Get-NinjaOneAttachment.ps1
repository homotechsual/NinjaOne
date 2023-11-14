
function Get-NinjaOneAttachment {
    <#
        .SYNOPSIS
            Gets an attachment from the NinjaOne API.
        .DESCRIPTION
            Retrieves an attachment from the NinjaOne v2 API.
        .FUNCTIONALITY
            Attachment
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The attachment id to retrieve.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [String]$attachmentId
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'attachmentid=' parameter by removing it from the set parameters.
    if ($attachmentID) {
        $Parameters.Remove('attachmentId') | Out-Null
    }
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        Write-Verbose 'Retrieving attachment.'
        $Resource = "v2/attachment/$($attachmentID)"
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $AttachmentResults = New-NinjaOneGETRequest @RequestParams
        Return $AttachmentResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}