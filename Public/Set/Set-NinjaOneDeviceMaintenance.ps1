
using namespace System.Management.Automation
#Requires -Version 7
function Set-NinjaOneDeviceMaintenance {
    <#
        .SYNOPSIS
            Sets a new maintenance window for the specified device(s)
        .DESCRIPTION
            Create a new maintenance window for the given device(s) using the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The device to set a maintenance window for.
        [Parameter(Mandatory = $true)]
        [string[]]$deviceId,
        # The features to disable during maintenance.
        [Parameter(Mandatory = $true)]
        [ValidateSet('ALERTS', 'PATCHING', 'AVSCANS', 'TASKS')]
        [string[]]$disabledFeatures,
        # The start date/time for the maintenance window - most date formats will work, if not set defaults to now.
        [Parameter()]
        [string]$start,
        # The end date/time for the maintenance window - most date formats will work.
        [Parameter(Mandatory = $true)]
        [string]$end
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding a 'deviceid=' parameter by removing it from the set parameters.
    if ($mode) {
        $Parameters.Remove('deviceId') | Out-Null
    }
    # Workaround to prevent the query string processor from adding a 'disabledfeatures=' parameter by removing it from the set parameters.
    if ($disabledFeatures) {
        $Parameters.Remove('disabledFeatures') | Out-Null
    }
    # Workaround to prevent the query string processor from adding a 'start=' parameter by removing it from the set parameters.
    if ($start) {
        $Parameters.Remove('start') | Out-Null
    }
    # Workaround to prevent the query string processor from adding an 'end=' parameter by removing it from the set parameters.
    if ($end) {
        $Parameters.Remove('end') | Out-Null
    }
    try {
        # Validate the dates.
        if ($start -and [DateTime]::Parse($start)) {
            $dateTimeStart = [DateTime]::Parse($start)
            $unixStart = Get-Date -Date $dateTimeStart -UFormat '%s'
        }
        if ($end -and [DateTime]::Parse($end)) {
            $dateTimeEnd = [DateTime]::Parse($end)
            $unixEnd = Get-Date -Date $dateTimeEnd -UFormat '%s'
        }
        $Resource = "v2/device/$deviceId/maintenance"
        $MaintenanceWindow = [PSCustomObject]@{
            disabledFeatures = [array]$disabledFeatures
            start = $unixStart
            end = $unixEnd
        }
        $RequestParams = @{
            Method = 'POST'
            Resource = $Resource
            Body = $MaintenanceWindow
        }
        if ($PSCmdlet.ShouldProcess('Device Maintenance', 'Set')) {
            $DeviceMaintenance = New-NinjaOnePUTRequest @RequestParams
            if ($DeviceMaintenance -eq 204) {
                Write-Information "Device $($deviceIds) maintenance window created successfully."
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}