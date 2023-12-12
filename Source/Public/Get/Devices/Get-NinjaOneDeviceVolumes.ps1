
function Get-NinjaOneDeviceVolumes {
    <#
        .SYNOPSIS
            Gets device volumes from the NinjaOne API.
        .DESCRIPTION
            Retrieves device volumes from the NinjaOne v2 API.
        .FUNCTIONALITY
            Device Volumes
        .EXAMPLE
            PS> Get-NinjaOneDeviceVolumes -deviceId 1

            Gets the volumes for the device with id 1.
        .EXAMPLE
            PS> Get-NinjaOneDeviceVolumes -deviceId 1 -include bl

            Gets the volumes for the device with id 1 and includes BitLocker status.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicevolumes
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Alias('gnodv')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Device id to get volumes for.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [Int]$deviceId,
        # Additional information to include currently known options are 'bl' for BitLocker status.
        [Parameter(Position = 1)]
        [String]$include
    )
    begin {
        $CommandName = $MyInvocation.InvocationName
        $Parameters = (Get-Command -Name $CommandName).Parameters
        # Workaround to prevent the query string processor from adding an 'deviceid=' parameter by removing it from the set parameters.
        $Parameters.Remove('deviceId') | Out-Null
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
    }
    process {
        try {
            
            Write-Verbose 'Getting device from NinjaOne API.'
            $Device = Get-NinjaOneDevices -deviceId $deviceId
            if ($Device) {
                Write-Verbose ('Getting volumes for device {0}.' -f $Device.SystemName)
                $Resource = ('v2/device/{0}/volumes' -f $deviceId)
            } else {
                throw ('Device with id {0} not found.' -f $deviceId)
            }
            $RequestParams = @{
                Resource = $Resource
                QSCollection = $QSCollection
            }
            $DeviceVolumeResults = New-NinjaOneGETRequest @RequestParams
            return $DeviceVolumeResults
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}