
function Get-NinjaOneDeviceSoftwarePatchInstalls {
    <#
        .SYNOPSIS
            Gets device software patch installs from the NinjaOne API.
        .DESCRIPTION
            Retrieves device software patch installs from the NinjaOne v2 API. If you want patch install status for multiple devices please check out the related 'queries' commandlet `Get-NinjaOneSoftwarePatchInstalls`.
        .EXAMPLE
            PS> Get-NinjaOneDeviceSoftwarePatchInstalls -deviceId 1

            Gets software patch installs for the device with id 1.
        .EXAMPLE
            PS> Get-NinjaOneDeviceSoftwarePatchInstalls -deviceId 1 -type 'PATCH' -impact 'RECOMMENDED' -status 'FAILED' -installedAfter (Get-Date 2022/01/01)

            Gets OS patch installs for the device with id 1 where the patch with type patch and impact / severity recommended failed to install after 2022-01-01.
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
        # Filter patches by type.
        [ValidateSet('PATCH', 'INSTALLER')]
        [string]$type,
        # Filter patches by impact.
        [ValidateSet('OPTIONAL', 'RECOMMENDED', 'CRITICAL')]
        [string]$impact,
        # Filter patches by patch status.
        [ValidateSet('FAILED', 'INSTALLED')]
        [String]$status,
        # Filter patches by product identifier.
        [String]$productIdentifier,
        # Filter patches to those installed before this date. PowerShell DateTime object.
        [DateTime]$installedBefore,
        # Filter patches to those installed after this date. Unix Epoch time.
        [Int]$installedBeforeUnixEpoch,
        # Filter patches to those installed after this date. PowerShell DateTime object.
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
        if ($deviceId) {
            Write-Verbose 'Getting device from NinjaOne API.'
            $Device = Get-NinjaOneDevices -deviceID $deviceId
            if ($Device) {
                Write-Verbose "Retrieving software patch installs for $($Device.SystemName)."
                $Resource = "v2/device/$($deviceId)/software-patch-installs"
            }
        }
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $DeviceSoftwarePatchIntallResults = New-NinjaOneGETRequest @RequestParams
        Return $DeviceSoftwarePatchIntallResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}