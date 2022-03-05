
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
        # The device to change servce configuration for.
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
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'deviceId=' parameter by removing it from the set parameters.
    if ($deviceIds) {
        $Parameters.Remove('deviceId') | Out-Null
    }
    # Workaround to prevent the query string processor from adding an 'serviceId=' parameter by removing it from the set parameters.
    if ($serviceId) {
        $Parameters.Remove('serviceId') | Out-Null
    }
    # Workaround to prevent the query string processor from adding an 'action=' parameter by removing it from the set parameters.
    if ($action) {
        $Parameters.Remove('action') | Out-Null
    }
    try {
        $Resource = "v2/device/$deviceId/windows-service/$serviceId/control"
        $RequestParams = @{
            Method = 'POST'
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