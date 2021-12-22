
using namespace System.Management.Automation
#Requires -Version 7
function Get-NinjaOneDeviceHealthReport {
    <#
        .SYNOPSIS
            Gets the device health report from the NinjaOne API.
        .DESCRIPTION
            Retrieves the device health report from the NinjaOne v2 API.
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
        # Filter by health status.
        [ValidateSet('UNHEALTHY', 'HEALTHY', 'UNKNOWN', 'NEEDS_ATTENTION')]
        [String]$health,
        # Cursor name.
        [String]$cursor,
        # Number of results per page.
        [Int]$pageSize
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = 'v2/queries/device-health'
        $RequestParams = @{
            Method = 'GET'
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $DeviceHealthReport = New-NinjaOneGETRequest @RequestParams
        Return $DeviceHealthReport
    } catch {
        $ErrorRecord = @{
            ExceptionType = 'System.Exception'
            ErrorRecord = $_
            ErrorCategory = 'ReadError'
            BubbleUpDetails = $True
            CommandName = $CommandName
        }
        New-NinjaOneError @ErrorRecord
    }
}