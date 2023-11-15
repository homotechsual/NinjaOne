
function Get-NinjaOneDeviceScriptingOptions {
    <#
        .SYNOPSIS
            Gets device scripting options from the NinjaOne API.
        .DESCRIPTION
            Retrieves device scripting options from the NinjaOne v2 API.
        .FUNCTIONALITY
            Device Scripting Options
        .EXAMPLE
            PS> Get-NinjaOneDeviceScriptingOptions -deviceId 1

            Gets the device scripting options for the device with id 1.
        .EXAMPLE
            PS> (Get-NinjaOneDeviceScriptingOptions -deviceId 1).scripts

            Gets the scripts for the device with id 1.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The device id to get the scripting options for.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [Int]$deviceId,
        # Built in scripts / job names should be returned in the specified language.
        [Parameter(Position = 1)]
        [Alias('lang')]
        [String]$LanguageTag
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'deviceid=' parameter by removing it from the set parameters.
    $Parameters.Remove('deviceId') | Out-Null
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        Write-Verbose 'Getting device from NinjaOne API.'
        $Device = Get-NinjaOneDevices -deviceId $deviceId
        if ($Device) {
            Write-Verbose ('Getting scripting options for device {0}.' -f $Device.SystemName)
            $Resource = ('v2/device/{0}/scripting/options' -f $deviceId)
        }
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $DeviceScriptingOptionResults = New-NinjaOneGETRequest @RequestParams
        if ($DeviceScriptingOptionResults) {
            return $DeviceScriptingOptionResults
        } else {
            throw ('No scripting options found for device {0}.' -f $Device.SystemName)
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}