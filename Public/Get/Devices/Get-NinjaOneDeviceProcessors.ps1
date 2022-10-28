#Requires -Version 7
function Get-NinjaOneDeviceProcessors {
    <#
        .SYNOPSIS
            Gets device processors from the NinjaOne API.
        .DESCRIPTION
            Retrieves device processors from the NinjaOne v2 API.
        .EXAMPLE
            PS> Get-NinjaOneDeviceProcessors -deviceId 1
            
            Gets the processors for the device with id 1.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Device id to get processor information for.
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        [Alias('id')]
        [Int]$deviceId
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
                Write-Verbose "Retrieving processors for $($Device.SystemName)."
                $Resource = "v2/device/$($deviceId)/processors"
            }
        }
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $DeviceProcessorResults = New-NinjaOneGETRequest @RequestParams
        Return $DeviceProcessorResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}