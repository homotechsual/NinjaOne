
using namespace System.Management.Automation
#Requires -Version 7
function Set-NinjaOneWindowsServiceConfiguration {
    <#
        .SYNOPSIS
            Sets the configuration of the given Windows Service for the given device.
        .DESCRIPTION
            Sets the configuration of the Windows Service for a single device using the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
        .EXAMPLE
            Set-NinjaOneWindowsServiceConfiguration -deviceId "12345" -serviceId "NinjaRMMAgent" -Configuration @{ startType = "AUTO_START"; userName = "LocalSystem" }
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
        # The configuration to set.
        [Parameter(Mandatory = $true)]
        [object]$configuration
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
    # Workaround to prevent the query string processor from adding an 'configuration=' parameter by removing it from the set parameters.
    if ($configuration) {
        $Parameters.Remove('configuration') | Out-Null
    }
    try {
        $Resource = "v2/device/$deviceId/windows-service/$serviceId/configure"
        $RequestParams = @{
            Method = 'POST'
            Resource = $Resource
            Body = $configuration
        }
        if ($PSCmdlet.ShouldProcess("Service $serviceId configuration", 'Set')) {
            $ServiceConfiguration = New-NinjaOnePOSTRequest @RequestParams
            if ($ServiceConfiguration -eq 204) {
                Write-Information "Service configuration for service $($serviceId) on device $($deviceId) updated successfully."
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}