function Remove-NinjaOneDeviceMaintenance {
    <#
        .SYNOPSIS
            Cancels scheduled maintenance for the given device.
        .DESCRIPTION
            Cancels scheduled maintenance for the given device using the NinjaOne v2 API.
        .FUNCTIONALITY
            Maintenance
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/maintenance
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The device Id to cancel maintenance for.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [Int]$deviceId
    )
    try {
        $Device = Get-NinjaOneDevice -deviceId $deviceId
        if ($Device) {
            $Resource = ('v2/device/{0}/maintenance' -f $deviceId)
        } else {
            throw ('Device with id {0} not found.' -f $deviceId)
        }
        $RequestParams = @{
            Resource = $Resource
        }
        if ($PSCmdlet.ShouldProcess(('{0} Maintenance' -f $Device.SystemName), 'Delete')) {
            $DeviceMaintenance = New-NinjaOneDELETERequest @RequestParams
            if ($DeviceMaintenance -eq 204) {
                $OIP = $InformationPreference
                $InformationPreference = 'Continue'
                Write-Information ('Scheduled device maintenance for device {0} deleted successfully.' -f $Device.SystemName)
                $InformationPreference = $OIP
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}