function Set-NinjaOneDeviceMaintenance {
    <#
        .SYNOPSIS
            Sets a new maintenance window for the specified device(s)
        .DESCRIPTION
            Schedule a new maintenance window for the given device(s) using the NinjaOne v2 API.
        .FUNCTIONALITY
            Device Maintenance
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/devicemaintenance
    #>
    [CmdletBinding( SupportsShouldProcess, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The device to set a maintenance window for.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [Int]$deviceId,
        # The features to disable during maintenance.
        [Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
        [ValidateSet('ALERTS', 'PATCHING', 'AVSCANS', 'TASKS')]
        [String[]]$disabledFeatures,
        # The start date/time for the maintenance window - PowerShell DateTime object.
        [Parameter(Position = 2)]
        [DateTime]$start,
        # The start date/time for the maintenance window - Unix Epoch time.
        [Parameter(Position = 2)]
        [Int]$unixStart,
        # The end date/time for the maintenance window - PowerShell DateTime object.
        [Parameter(Position = 3)]
        [DateTime]$end,
        # The end date/time for the maintenance window - Unix Epoch time.
        [Parameter(Position = 3)]
        [Int]$unixEnd
    )
    try {
        $Device = Get-NinjaOneDevice -deviceId $deviceId
        if ($Device) {
            Write-Verbose ('Setting maintenance window for device {0}.' -f $Device.SystemName)
            if ($start) {
                [Int]$start = ConvertTo-UnixEpoch -DateTime $start
            } elseif ($unixStart) {
                $Parameters.Remove('unixStart') | Out-Null
                [Int]$start = $unixStart
            }
            if ($end) {
                [Int]$end = ConvertTo-UnixEpoch -DateTime $end
            } elseif ($unixEnd) {
                $Parameters.Remove('unixEnd') | Out-Null
                [Int]$end = $unixEnd
            } else {
                throw 'An end date/time must be specified.'
            }
            $Resource = ('v2/device/{0}/maintenance' -f $deviceId)
        } else {
            throw ('Device with id {0} not found.' -f $deviceId)
        }
        $MaintenanceWindow = @{
            disabledFeatures = [Array]$disabledFeatures
            start = $start
            end = $end
        }
        $RequestParams = @{
            Resource = $Resource
            Body = $MaintenanceWindow
        }
        if ($PSCmdlet.ShouldProcess(('Device Maintenance for {0}' -f $Device.SystemName), 'Set')) {
            $DeviceMaintenance = New-NinjaOnePUTRequest @RequestParams -ErrorAction Stop
            if ($DeviceMaintenance -eq 204) {
                $OIP = $InformationPreference
                $InformationPreference = 'Continue'
                Write-Information ('Maintenance window for {0} set successfully.' -f $Device.SystemName)
                $InformationPreference = $OIP
            }
        }
    } catch [System.IO.InvalidDataException] {
        throw $_
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}