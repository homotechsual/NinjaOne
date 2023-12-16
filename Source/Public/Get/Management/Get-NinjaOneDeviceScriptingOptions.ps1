
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
            PS> Get-NinjaOneDeviceScriptingOptions -deviceId 1 -Scripts

            Gets the scripts for the device with id 1.
        .EXAMPLE
            PS> Get-NinjaOneDeviceScriptingOptions -deviceId 1 -Categories

            Gets the categories for the device with id 1.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicescriptingoptions
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Alias('gnodso')]
    [Metadata(
        '/v2/device/{id}/scripting/options',
        'get'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The device id to get the scripting options for.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [Int]$deviceId,
        # Built in scripts / job names should be returned in the specified language.
        [Parameter(Position = 1)]
        [Alias('lang')]
        [String]$LanguageTag,
        # Return the categories list only.
        [Switch]$Categories,
        # Return the scripts list only.
        [Switch]$Scripts
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
                Write-Verbose ('Getting scripting options for device {0}.' -f $Device.SystemName)
                $Resource = ('v2/device/{0}/scripting/options' -f $deviceId)
            }
            $RequestParams = @{
                Resource = $Resource
                QSCollection = $QSCollection
            }
            $DeviceScriptingOptionResults = New-NinjaOneGETRequest @RequestParams
            if ($DeviceScriptingOptionResults) {
                if ($Categories) {
                    return $DeviceScriptingOptionResults.Categories
                } elseif ($Scripts) {
                    return $DeviceScriptingOptionResults.Scripts
                } else {
                    return $DeviceScriptingOptionResults
                }
            } else {
                throw ('No scripting options found for device {0}.' -f $Device.SystemName)
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}