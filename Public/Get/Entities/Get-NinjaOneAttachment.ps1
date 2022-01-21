#Requires -Version 7
function Get-NinjaOneAtachment {
    <#
        .SYNOPSIS
            Gets an attachment from the NinjaOne API.
        .DESCRIPTION
            Retrieves an attachment from the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Filter by device ID.
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        [Alias('id')]
        [Int]$attachmentID
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'attachmentid=' parameter by removing it from the set parameters.
    if ($attachmentID) {
        $Parameters.Remove('attachmentID') | Out-Null
    }
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        Write-Verbose 'Retrieving attachment.'
        $Resource = "v2/attachment/$(attachmentID)"
        $RequestParams = @{
            Method = 'GET'
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $AttachmentResults = New-NinjaOneGETRequest @RequestParams
        Return $AttachmentResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}