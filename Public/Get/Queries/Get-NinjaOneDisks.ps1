function Get-NinjaOneDisks {
    <#
        .SYNOPSIS
            Gets the disks from the NinjaOne API.
        .DESCRIPTION
            Retrieves the disks from the NinjaOne v2 API.
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
        # Cursor name.
        [String]$cursor,
        # Number of results per page.
        [Int]$pageSize
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = 'v2/queries/disks'
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $Disks = New-NinjaOneGETRequest @RequestParams
        Return $Disks
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}