
using namespace System.Management.Automation
#Requires -Version 7
function Invoke-NinjaOneWindowsServiceAction {
    <#
        .SYNOPSIS
            Runs an action against the given Windows Service for the given device.
        .DESCRIPTION
            Runs an action against a windows service on a single device using the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The device to change service configuration for.
        [Parameter(Mandatory = $true)]
        [string[]]$deviceId,
        # The service to alter configuration for.
        [Parameter(Mandatory = $true)]
        [object]$serviceId,
        # The action to invoke.
        [Parameter(Mandatory = $true)]
        [ValidateSet('START', 'PAUSE', 'STOP', 'RESTART')]
        [object]$action
    )
    try {
        $Resource = "v2/device/$deviceId/windows-service/$serviceId/control"
        $RequestParams = @{
            Resource = $Resource
            Body = @{
                action = $action
            }
        }
        if ($PSCmdlet.ShouldProcess("Service $serviceId configuration", 'Set')) {
            $ServiceAction = New-NinjaOnePOSTRequest @RequestParams
            if ($ServiceAction -eq 204) {
                Write-Information "Requested $($action) on service $($serviceId) on device $($deviceId) successfully."
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}