
using namespace System.Management.Automation
#Requires -Version 7
function Get-NinjaOneRAIDControllers {
    <#
        .SYNOPSIS
            Gets the RAID controllers from the NinjaOne API.
        .DESCRIPTION
            Retrieves the RAID controllers from the NinjaOne v2 API.
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