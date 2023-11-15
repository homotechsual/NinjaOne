function Set-NinjaOneDevice {
    <#
        .SYNOPSIS
            Sets device information, like friendly name, user data etc.
        .DESCRIPTION
            Sets device information using the NinjaOne v2 API.
        .FUNCTIONALITY
            Device
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The device to set the information for.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [Int]$deviceId,
        # The device information body object.
        [Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
        [Object]$deviceInformation
    )
    try {
        $Device = Get-NinjaOneDevice -deviceId $deviceId
        if ($Device) {
            Write-Verbose ('Setting device information for device {0}.' -f $Device.SystemName)
            $Resource = ('v2/device/{0}' -f $deviceId)
        } else {
            throw ('Device with id {0} not found.' -f $deviceId)
        }
        $RequestParams = @{
            Resource = $Resource
            Body = $deviceInformation
        }
        if ($PSCmdlet.ShouldProcess(('Device {0} information' -f $Device.SystemName), 'Update')) {
            $DeviceUpdate = New-NinjaOnePATCHRequest @RequestParams
            if ($DeviceUpdate -eq 204) {
                $OIP = $InformationPreference
                $InformationPreference = 'Continue'
                Write-Information ('Device {0} information updated successfully.' -f $Device.SystemName)
                $InformationPreference = $OIP
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}