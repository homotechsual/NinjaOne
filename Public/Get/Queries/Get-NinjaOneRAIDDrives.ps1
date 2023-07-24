function Get-NinjaOneRAIDDrives {
    <#
        .SYNOPSIS
            Gets the RAID drives from the NinjaOne API.
        .DESCRIPTION
            Retrieves the RAID drives from the NinjaOne v2 API.
        .EXAMPLE
            PS> Get-NinjaOneRAIDDrives

            Gets the RAID drives.
        .EXAMPLE
            PS> Get-NinjaOneRAIDDrives -deviceFilter 'org = 1'

            Gets the RAID drives for the organisation with id 1.
        .EXAMPLE
            PS> Get-NinjaOneRAIDDrives -timeStamp 1619712000

            Gets the RAID drives with a monitoring timestamp at or after 1619712000.
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
        $Resource = 'v2/queries/raid-drives'
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $RAIDDrives = New-NinjaOneGETRequest @RequestParams
        Return $RAIDDrives
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}