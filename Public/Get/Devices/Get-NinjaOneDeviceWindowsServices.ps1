#Requires -Version 7
function Get-NinjaOneDeviceWindowsServices {
    <#
        .SYNOPSIS
            Gets device windows services from the NinjaOne API.
        .DESCRIPTION
            Retrieves device windows services from the NinjaOne v2 API.
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
        # Filter by service name.
        [String]$name,
        # Filter by service state.
        [ValidateSet(
            'UNKNOWN',
            'STOPPED',
            'START_PENDING',
            'RUNNING',
            'STOP_PENDING',
            'PAUSE_PENDING',
            'PAUSED',
            'CONTINUE_PENDING'
        )]
        [String]$state
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
                Write-Verbose "Retrieving windows services for $($Device.SystemName)."
                $Resource = "v2/device/$($deviceId)/windows-services"
            }
        }
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $DeviceWindowsServiceResults = New-NinjaOneGETRequest @RequestParams
        Return $DeviceWindowsServiceResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}