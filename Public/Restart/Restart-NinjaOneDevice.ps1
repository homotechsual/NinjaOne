function Restart-NinjaOneDevice {
    <#
        .SYNOPSIS
            Reboots a device using the NinjaOne API.
        .DESCRIPTION
            Triggers a device reboot using the NinjaOne v2 API.
        .FUNCTIONALITY
            Device
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The device Id to reset status for.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [Int]$deviceId,
        # The reboot mode.
        [Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
        [ValidateSet('NORMAL', 'FORCED')]
        [String]$mode,
        # The reboot reason.
        [Parameter()]
        [String]$reason
    )
    try {
        $Device = Get-NinjaOneDevice -deviceId $deviceId
        if ($Device) {
            Write-Verbose ('Rebooting device {0}.' -f $Device.SystemName)
            $Resource = ('v2/device/{0}/reboot/{1}' -f $deviceId, $mode)
        } else {
            throw ('Device with id {0} not found.' -f $deviceId)
        }
        $RequestParams = @{
            Resource = $Resource
        }
        if ($reason) {
            $reasonObject = @{
                reason = $reason
            }
            $RequestParams.Add('body', $reasonObject)
        }
        if ($PSCmdlet.ShouldProcess(('Device' -f $Device.SystemName), 'Reboot')) {
            $Alert = New-NinjaOnePOSTRequest @RequestParams
            if ($Alert -eq 204) {
                $OIP = $InformationPreference
                $InformationPreference = 'Continue'
                Write-Information ('Device {0} rebooted command sent successfully.' -f $Device.SystemName)
                $InformationPreference = $OIP
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}