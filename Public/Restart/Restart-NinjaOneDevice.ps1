
using namespace System.Management.Automation
#Requires -Version 7
function Restart-NinjaOneDevice {
    <#
        .SYNOPSIS
            Reboots a device using the NinjaOne API.
        .DESCRIPTION
            Triggers a device reboot using the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The device ID to reset status for.
        [Parameter(Mandatory = $true)]
        [string]$deviceId,
        # The reboot mode.
        [Parameter(Mandatory = $true)]
        [ValidateSet('NORMAL', 'FORCED')]
        [string]$mode,
        # The reboot reason.
        [Parameter()]
        [string]$reason
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding a 'deviceId=' parameter by removing it from the set parameters.
    if ($deviceId) {
        $Parameters.Remove('deviceId') | Out-Null
    }
    # Workaround to prevent the query string processor from adding a 'mode=' parameter by removing it from the set parameters.
    if ($mode) {
        $Parameters.Remove('mode') | Out-Null
    }
    # Workaround to prevent the query string processor from adding a 'reason=' parameter by removing it from the set parameters.
    if ($reason) {
        $Parameters.Remove('reason') | Out-Null
    }
    try {
        $Resource = "v2/device/$deviceId/reboot/$mode"
        $RequestParams = @{
            Method = 'POST'
            Resource = $Resource
        }
        if ($reason) {
            $reasonObject = @{
                reason = $reason
            }
            $RequestParams.Add('reason', $reasonObject)
        }
        if ($PSCmdlet.ShouldProcess("Device $deviceId", 'Reboot')) {
            $Alert = New-NinjaOnePOSTRequest @RequestParams
            if ($Alert -eq 204) {
                Write-Information "Device $deviceId reboot command sent successfully."
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}