
function Get-NinjaOneDeviceProcessors {
    <#
        .SYNOPSIS
            Gets device processors from the NinjaOne API.
        .DESCRIPTION
            Retrieves device processors from the NinjaOne v2 API.
        .FUNCTIONALITY
            Device Processors
        .EXAMPLE
            PS> Get-NinjaOneDeviceProcessors -deviceId 1
            
            Gets the processors for the device with id 1.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/deviceprocessors
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Alias('gnodp')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Device id to get processor information for.
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
                Write-Verbose ('Getting processors for device {0}.' -f $Device.SystemName)
                $Resource = ('v2/device/{0}/processors' -f $deviceId)
            } else {
                throw ('Device with id {0} not found.' -f $deviceId)
            }
            $RequestParams = @{
                Resource = $Resource
                QSCollection = $QSCollection
            }
            $DeviceProcessorResults = New-NinjaOneGETRequest @RequestParams
            return $DeviceProcessorResults
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}