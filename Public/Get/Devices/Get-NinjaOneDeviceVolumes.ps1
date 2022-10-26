#Requires -Version 7
function Get-NinjaOneDeviceVolumes {
    <#
        .SYNOPSIS
            Gets device volumes from the NinjaOne API.
        .DESCRIPTION
            Retrieves device volumes from the NinjaOne v2 API.
        .EXAMPLE
            PS> Get-NinjaOneDeviceVolumes -deviceId 1
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Device ID
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        [Alias('id')]
        [Int]$deviceId,
        # Additional information to include (bl - BitLocker status)
        [String]$include
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'deviceid=' parameter by removing it from the set parameters.
    if ($deviceId) {
        $Parameters.Remove('deviceID') | Out-Null
    }
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        if ($deviceId) {
            Write-Verbose 'Getting device from NinjaOne API.'
            $Device = Get-NinjaOneDevices -deviceID $deviceId
            if ($Device) {
                Write-Verbose "Retrieving volumes for $($Device.SystemName)."
                $Resource = "v2/device/$($deviceId)/volumes"
            }
        }
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $DeviceVolumeResults = New-NinjaOneGETRequest @RequestParams
        Return $DeviceVolumeResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}