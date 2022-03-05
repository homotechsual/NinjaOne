
using namespace System.Management.Automation
#Requires -Version 7
function Update-NinjaOneDevice {
    <#
        .SYNOPSIS
            Updates device information, like friendly name, user data etc.
        .DESCRIPTION
            Updates device information using the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The device to set the information for.
        [Parameter(Mandatory = $true)]
        [string[]]$deviceId,
        # The device information body object.
        [Parameter(Mandatory = $true)]
        [object]$deviceInformation
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'deviceId=' parameter by removing it from the set parameters.
    if ($deviceIds) {
        $Parameters.Remove('deviceId') | Out-Null
    }
    # Workaround to prevent the query string processor from adding an 'deviceInformation=' parameter by removing it from the set parameters.
    if ($deviceInformation) {
        $Parameters.Remove('deviceInformation') | Out-Null
    }
    try {
        $Resource = "v2/device/$deviceId"
        $RequestParams = @{
            Method = 'PATCH'
            Resource = $Resource
            Body = $deviceInformation
        }
        if ($PSCmdlet.ShouldProcess('Device information', 'Update')) {
            $DeviceUpdate = New-NinjaOnePOSTRequest @RequestParams
            if ($DeviceUpdate -eq 204) {
                Write-Information "Device information for device $($deviceId) updated successfully."
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}