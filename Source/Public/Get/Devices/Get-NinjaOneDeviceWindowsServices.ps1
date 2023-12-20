
function Get-NinjaOneDeviceWindowsServices {
    <#
        .SYNOPSIS
            Gets device windows services from the NinjaOne API.
        .DESCRIPTION
            Retrieves device windows services from the NinjaOne v2 API.
        .FUNCTIONALITY
            Device Windows Services
        .EXAMPLE
            PS> Get-NinjaOneDeviceWindowsServices -deviceId 1

            Gets all windows services for the device with id 1.
        .EXAMPLE
            PS> Get-NinjaOneDeviceWindowsServices -deviceId 1 -name 'NinjaRMM Agent'

            Gets all windows services for the device with id 1 that match the name 'NinjaRMM Agent'.
        .EXAMPLE
            PS> Get-NinjaOneDeviceWindowsServices -deviceId 1 -state 'RUNNING'

            Gets all windows services for the device with id 1 that are in the 'RUNNING' state.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicewindowsservices
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Alias('gnodws')]
    [MetadataAttribute(
        '/v2/device/{id}/windows-services',
        'get'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Device id to get windows services for.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [Int]$deviceId,
        # Filter by service name. Ninja interprets this case sensitively.
        [Parameter(Position = 1)]
        [String]$name,
        # Filter by service state.
        [Parameter(Position = 2)]
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
                Write-Verbose ('Getting windows services for device {0}.' -f $Device.SystemName)
                $Resource = ('v2/device/{0}/windows-services' -f $deviceId)
            } else {
                throw ('Device with id {0} not found.' -f $deviceId)
            }
            $RequestParams = @{
                Resource = $Resource
                QSCollection = $QSCollection
            }
            $DeviceWindowsServiceResults = New-NinjaOneGETRequest @RequestParams
            return $DeviceWindowsServiceResults
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}