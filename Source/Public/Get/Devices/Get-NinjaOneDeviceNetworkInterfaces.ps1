
function Get-NinjaOneDeviceNetworkInterfaces {
    <#
        .SYNOPSIS
            Gets device network interfaces from the NinjaOne API.
        .DESCRIPTION
            Retrieves device network interfaces from the NinjaOne v2 API.
        .FUNCTIONALITY
            Device Network Interfaces
        .EXAMPLE
            PS> Get-NinjaOneDeviceNetworkInterfaces -deviceId 1

            Gets the network interfaces for the device with id 1.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicelastloggedonuser
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Alias('gnodni')]
    [MetadataAttribute(
        '/v2/device/{id}/network-interfaces',
        'get'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Device id to get the network interfaces for.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [Int]$deviceId
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
                Write-Verbose ('Getting network interfaces for device {0}.' -f $Device.SystemName)
                $Resource = ('v2/device/{0}/network-interfaces' -f $deviceId)
            } else {
                throw ('Device with id {0} not found.' -f $deviceId)
            }
            $RequestParams = @{
                Resource = $Resource
                QSCollection = $QSCollection
            }
            $DeviceNetworkInterfaceResults = New-NinjaOneGETRequest @RequestParams
            return $DeviceNetworkInterfaceResults
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}