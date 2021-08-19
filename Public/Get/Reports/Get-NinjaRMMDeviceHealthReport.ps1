
using namespace System.Management.Automation
#Requires -Version 7
function Get-NinjaRMMDeviceHealthReport {
    <#
        .SYNOPSIS
            Gets the device health report from the NinjaRMM API.
        .DESCRIPTION
            Retrieves the device health report from the NinjaRMM v2 API.
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
        [String]$health,
        # Cursor name.
        [String]$cursor,
        # Number of results per page.
        [Int]$pageSize
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaRMMQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = 'v2/queries/device-health'
        $RequestParams = @{
            Method = 'GET'
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $DeviceHealthReport = New-NinjaRMMGETRequest @RequestParams
        Return $DeviceHealthReport
    } catch {
        $CommandFailedError = [ErrorRecord]::New(
            [System.Exception]::New(
                'Failed to get the device health report from NinjaRMM. You can use "Get-Error" for detailed error information.',
                $_.Exception
            ),
            'NinjaCommandFailed',
            'ReadError',
            $TargetObject
        )
        $PSCmdlet.ThrowTerminatingError($CommandFailedError)
    }
}