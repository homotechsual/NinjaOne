
function Get-NinjaOneDeviceOSPatchInstalls {
    <#
        .SYNOPSIS
            Gets device OS patch installs from the NinjaOne API.
        .DESCRIPTION
            Retrieves device OS patch installs from the NinjaOne v2 API. If you want patch install status for multiple devices please check out the related 'queries' commandlet `Get-NinjaOneOSPatchInstalls`.
        .EXAMPLE
            PS> Get-NinjaOneDeviceOSPatchInstalls -deviceId 1

            Gets OS patch installs for the device with id 1.
        .EXAMPLE
            PS> Get-NinjaOneDeviceOSPatchInstalls -deviceId 1 -status 'FAILED' -installedAfter (Get-Date 2022/01/01)

            Gets OS patch installs for the device with id 1 where the patch failed to install after 2022-01-01.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Device id to get OS patch install information for.
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        [Alias('id')]
        [Int]$deviceId,
        # Filter patches by patch status.
        [ValidateSet('FAILED', 'INSTALLED')]
        [String]$status,
        # Filter patches to those installed before this date. Expects DateTime or Int.
        [DateTime]$installedBefore,
        # Filter patches to those installed after this date. Unix Epoch time.
        [Int]$installedBeforeUnixEpoch,
        # Filter patches to those installed after this date. Expects DateTime or Int.
        [DateTime]$installedAfter,
        # Filter patches to those installed after this date. Unix Epoch time.
        [Int]$installedAfterUnixEpoch
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'deviceid=' parameter by removing it from the set parameters.
    if ($deviceId) {
        $Parameters.Remove('deviceID') | Out-Null
    }
    if ($installedBefore) {
        [Int]$installedBefore = ConvertTo-UnixEpoch -DateTime $installedBefore
    }
    if ($installedBeforeUnixEpoch) {
        $Parameters.Remove('installedBeforeUnixEpoch') | Out-Null
        [Int]$installedBefore = $installedBeforeUnixEpoch
    }
    if ($installedAfter) {
        [Int]$installedAfter = ConvertTo-UnixEpoch -DateTime $installedAfter
    }
    if ($installedAfterUnixEpoch) {
        $Parameters.Remove('installedAfterUnixEpoch') | Out-Null
        [Int]$installedAfter = $installedAfterUnixEpoch
    }
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        Write-Verbose 'Getting device from NinjaOne API.'
        $Device = Get-NinjaOneDevices -deviceId $deviceId
        if ($Device) {
            Write-Verbose "Retrieving OS patch installs for $($Device.SystemName)."
            $Resource = "v2/device/$($deviceId)/os-patch-installs"
            $RequestParams = @{
                Resource = $Resource
                QSCollection = $QSCollection
            }
            $DeviceOSPatchInstallResults = New-NinjaOneGETRequest @RequestParams
            Return $DeviceOSPatchInstallResults
        } else {
            throw "Device with id $($deviceId) not found."
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}