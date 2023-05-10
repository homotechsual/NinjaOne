function Set-NinjaOneDeviceMaintenance {
    <#
        .SYNOPSIS
            Sets a new maintenance window for the specified device(s)
        .DESCRIPTION
            Create a new maintenance window for the given device(s) using the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The device to set a maintenance window for.
        [Parameter(Mandatory)]
        [string]$deviceId,
        # The features to disable during maintenance.
        [Parameter(Mandatory)]
        [ValidateSet('ALERTS', 'PATCHING', 'AVSCANS', 'TASKS')]
        [string[]]$disabledFeatures,
        # The start date/time for the maintenance window - PowerShell DateTime object.
        [DateTime]$start,
        # The start date/time for the maintenance window - Unix Epoch time.
        [Int]$unixStart,
        # The end date/time for the maintenance window - PowerShell DateTime object.
        [DateTime]$end,
        # The end date/time for the maintenance window - Unix Epoch time.
        [Int]$unixEnd
    )
    try {
        if ($start) {
            $start = ConvertTo-UnixEpoch -DateTime $start
        } elseif ($unixStart) {
            $Parameters.Remove('unixStart') | Out-Null
            $start = $unixStart
        }
        if ($end) {
            $end = ConvertTo-UnixEpoch -DateTime $end
        } elseif ($unixEnd) {
            $Parameters.Remove('unixEnd') | Out-Null
            $end = $unixEnd
        } else {
            throw 'An end date/time must be specified.'
        }
        $Resource = "v2/device/$deviceId/maintenance"
        $MaintenanceWindow = @{
            disabledFeatures = [array]$disabledFeatures
            start = $start
            end = $end
        }
        $RequestParams = @{
            Resource = $Resource
            Body = $MaintenanceWindow
        }
        if ($PSCmdlet.ShouldProcess('Device Maintenance', 'Set')) {
            $DeviceMaintenance = New-NinjaOnePUTRequest @RequestParams -ErrorAction Stop
            if ($DeviceMaintenance -eq 204) {
                Write-Information "Device $($deviceIds) maintenance window created successfully."
            }
        }
    } catch [System.IO.InvalidDataException] {
        throw $_
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}