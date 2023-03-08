function Get-NinjaOneAntivirusStatus {
    <#
        .SYNOPSIS
            Gets the antivirus status from the NinjaOne API.
        .DESCRIPTION
            Retrieves the antivirus status from the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Filter devices.
        [Alias('df')]
        [String]$deviceFilter,
        # Monitoring timestamp filter.
        [Alias('ts')]
        [string]$timeStamp,
        # Filter by product state.
        [String]$productState,
        # Filter by product name.
        [string]$productName,
        # Cursor name.
        [String]$cursor,
        # Number of results per page.
        [Int]$pageSize
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = 'v2/queries/antivirus-status'
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $AntivirusStatus = New-NinjaOneGETRequest @RequestParams
        Return $AntivirusStatus
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}