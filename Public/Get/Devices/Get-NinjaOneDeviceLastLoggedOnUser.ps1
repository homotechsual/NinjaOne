#Requires -Version 7
function Get-NinjaOneDeviceLastLoggedOnUser {
    <#
        .SYNOPSIS
            Gets device last logged on user from the NinjaOne API.
        .DESCRIPTION
            Retrieves device last logged on user from the NinjaOne v2 API.
        .EXAMPLE
            PS> Get-NinjaOneDeviceLastLoggedOnUser -deviceId 1

            Gets the last logged on user for the device with id 1.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/get/devices/get-ninjaonedevicelastloggedonuser
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Device id to get the last logged on user for.
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
                Write-Verbose "Retrieving last logged on user for $($Device.SystemName)."
                $Resource = "v2/device/$($deviceId)/last-logged-on-user"
            }
        }
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $DeviceLastLoggedOnUserResults = New-NinjaOneGETRequest @RequestParams
        Return $DeviceLastLoggedOnUserResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}