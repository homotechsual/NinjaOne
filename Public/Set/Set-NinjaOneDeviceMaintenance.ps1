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
        [string]$deviceId,
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
    try {
        Write-Debug 'Into try block.'
        # Validate the dates.
        if ($start -and $start -as [DateTime]) {
            Write-Verbose 'Parsing start date/time.'
            $dateTimeStart = [DateTime]::Parse($start)
            if ($dateTimeStart -lt [DateTime]::Now) {
                throw [System.IO.InvalidDataException]::New('Start date/time must be in the future.')
            }
            $unixStart = Get-Date -Date $dateTimeStart -UFormat '%s'
        }
        Write-Verbose 'Parsed start date/time.'
        if ($end -as [DateTime]) {
            Write-Verbose 'Parsing end date/time.'
            $dateTimeEnd = [DateTime]::Parse($end)
            if ($dateTimeEnd -lt [DateTime]::Now -or $dateTimeEnd -lt $dateTimeStart) {
                throw [System.IO.InvalidDataException]::New('End date/time must be in the future and after the start date/time.')
            }
            $unixEnd = Get-Date -Date $dateTimeEnd -UFormat '%s'
        }
        Write-Verbose 'Parsed dates.'
        $Resource = "v2/device/$deviceId/maintenance"
        $MaintenanceWindow = @{
            disabledFeatures = [array]$disabledFeatures
            start = $unixStart
            end = $unixEnd
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