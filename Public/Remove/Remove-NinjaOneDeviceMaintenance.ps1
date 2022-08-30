
using namespace System.Management.Automation
#Requires -Version 7
function Remove-NinjaOneDeviceMaintenance {
    <#
        .SYNOPSIS
            Cancels scheduled maintenance for the given device.
        .DESCRIPTION
            Cancels scheduled maintenance for the given device using the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The device ID to cancel maintenance for.
        [Parameter(Mandatory = $true)]
        [Int]$deviceId
    )
    try {
        $Resource = "v2/device/$deviceId/maintenance"
        $RequestParams = @{
            Resource = $Resource
        }
        $DeviceExists = (Get-NinjaOneDevices -deviceId $deviceId).Count -gt 0
        if ($DeviceExists) {
            if ($PSCmdlet.ShouldProcess('Device Maintenance', 'Delete')) {
                $DeviceMaintenance = New-NinjaOneDELETERequest @RequestParams
                if ($DeviceMaintenance -eq 204) {
                    Write-Information 'Scheduled device maintenance deleted successfully.'
                }
            }
        } else {
            throw "Device with ID $deviceId does not exist."
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}