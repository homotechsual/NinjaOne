#Requires -Version 7
function Get-NinjaOneDeviceScriptingOptions {
    <#
        .SYNOPSIS
            Gets device scripting options from the NinjaOne API.
        .DESCRIPTION
            Retrieves device scripting options from the NinjaOne v2 API.
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
        [Int]$deviceID,
        # Language tag
        [Alias('lang')]
        [String]$LanguageTag
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'deviceid=' parameter by removing it from the set parameters.
    if ($deviceID) {
        $Parameters.Remove('deviceID') | Out-Null
    }
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        if ($deviceID) {
            Write-Verbose 'Getting device from NinjaOne API.'
            $Device = Get-NinjaOneDevices -deviceID $deviceID
            if ($Device) {
                Write-Verbose "Retrieving scripting options for $($Device.SystemName)."
                $Resource = "v2/device/$($deviceID)/scripting/options"
            }
        }
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $DeviceScriptingOptionResults = New-NinjaOneGETRequest @RequestParams
        Return $DeviceScriptingOptionResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}