#Requires -Version 7
function Get-NinjaOneDeviceDisks {
    <#
        .SYNOPSIS
            Gets device disks from the NinjaOne API.
        .DESCRIPTION
            Retrieves device disks from the NinjaOne v2 API.
        .EXAMPLE
            PS> Get-NinjaOneDeviceDisks -deviceId 1

            Gets the disks for the device with id 1.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/get/devices/get-ninjaonedevicedisks
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Device id to get disk information for.
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        [Alias('id')]
        [Int]$deviceId
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'deviceid=' parameter by removing it from the set parameters.
    if ($deviceId) {
        $Parameters.Remove('deviceId') | Out-Null
    }
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        if ($deviceId) {
            Write-Verbose 'Getting device from NinjaOne API.'
            $Device = Get-NinjaOneDevices -deviceID $deviceId
            if ($Device) {
                Write-Verbose "Retrieving disk drives for $($Device.SystemName)."
                $Resource = "v2/device/$($deviceId)/disks"
            }
        }
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $DeviceDiskResults = New-NinjaOneGETRequest @RequestParams
        Return $DeviceDiskResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}