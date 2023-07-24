function Get-NinjaOneRAIDControllers {
    <#
        .SYNOPSIS
            Gets the RAID controllers from the NinjaOne API.
        .DESCRIPTION
            Retrieves the RAID controllers from the NinjaOne v2 API.
        .EXAMPLE
            PS> Get-NinjaOneRAIDControllers

            Gets the RAID controllers.
        .EXAMPLE
            PS> Get-NinjaOneRAIDControllers -deviceFilter 'org = 1'

            Gets the RAID controllers for the organisation with id 1.
        .EXAMPLE
            PS> Get-NinjaOneRAIDControllers -timeStamp 1619712000

            Gets the RAID controllers with a monitoring timestamp at or after 1619712000.
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
        $Resource = 'v2/queries/raid-controllers'
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $RAIDControllers = New-NinjaOneGETRequest @RequestParams
        Return $RAIDControllers
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}