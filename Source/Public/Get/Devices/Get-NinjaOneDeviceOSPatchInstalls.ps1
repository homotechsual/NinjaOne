
function Get-NinjaOneDeviceOSPatchInstalls {
    <#
        .SYNOPSIS
            Gets device OS patch installs from the NinjaOne API.
        .DESCRIPTION
            Retrieves device OS patch installs from the NinjaOne v2 API. If you want patch install status for multiple devices please check out the related 'queries' commandlet `Get-NinjaOneOSPatchInstalls`.
        .FUNCTIONALITY
            Device OS Patch Installs
        .EXAMPLE
            PS> Get-NinjaOneDeviceOSPatchInstalls -deviceId 1

            Gets OS patch installs for the device with id 1.
        .EXAMPLE
            PS> Get-NinjaOneDeviceOSPatchInstalls -deviceId 1 -status 'FAILED' -installedAfter (Get-Date 2022/01/01)

            Gets OS patch installs for the device with id 1 where the patch failed to install after 2022-01-01.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/deviceospatchinstalls
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Alias('gnodospi')]
    [MetadataAttribute(
        '/v2/device/{id}/os-patch-installs',
        'get'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Device id to get OS patch install information for.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [Int]$deviceId,
        # Filter patches by patch status.
        [Parameter(Position = 1)]
        [ValidateSet('FAILED', 'INSTALLED')]
        [String]$status,
        # Filter patches to those installed before this date. Expects DateTime or Int.
        [Parameter(Position = 2)]
        [DateTime]$installedBefore,
        # Filter patches to those installed after this date. Unix Epoch time.
        [Parameter(Position = 2)]
        [Int]$installedBeforeUnixEpoch,
        # Filter patches to those installed after this date. Expects DateTime or Int.
        [Parameter(Position = 3)]
        [DateTime]$installedAfter,
        # Filter patches to those installed after this date. Unix Epoch time.
        [Parameter(Position = 3)]
        [Int]$installedAfterUnixEpoch
    )
    begin {
        $CommandName = $MyInvocation.InvocationName
        $Parameters = (Get-Command -Name $CommandName).Parameters
        Write-Verbose ('Parameters: {0}' -f ($Parameters | Out-String))
        # Workaround to prevent the query string processor from adding an 'deviceid=' parameter by removing it from the set parameters.
        $Parameters.Remove('deviceId') | Out-Null
        # If the [DateTime] parameter $installedBefore is set convert the value to a Unix Epoch.
        if ($installedBefore) {
            [Int]$installedBefore = ConvertTo-UnixEpoch -DateTime $installedBefore
        }
        # If the Unix Epoch parameter $installedBeforeUnixEpoch is set assign the value to the $installedBefore variable and null $installedBeforeUnixEpoch.
        if ($installedBeforeUnixEpoch) {
            $Parameters.Remove('installedBeforeUnixEpoch') | Out-Null
            [Int]$installedBefore = $installedBeforeUnixEpoch
        }
        # If the [DateTime] parameter $installedAfter is set convert the value to a Unix Epoch.
        if ($installedAfter) {
            [Int]$installedAfter = ConvertTo-UnixEpoch -DateTime $installedAfter
        }
        # If the Unix Epoch parameter $installedAfterUnixEpoch is set assign the value to the $installedAfter variable and null $installedAfterUnixEpoch.
        if ($installedAfterUnixEpoch) {
            $Parameters.Remove('installedAfterUnixEpoch') | Out-Null
            [Int]$installedAfter = $installedAfterUnixEpoch
        }
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
    }
    process {
        try {
            
            Write-Verbose 'Getting device from NinjaOne API.'
            $Device = Get-NinjaOneDevices -deviceId $deviceId
            if ($Device) {
                Write-Verbose ('Getting OS patch installs for device {0}.' -f $Device.SystemName)
                $Resource = ('v2/device/{0}/os-patch-installs' -f $deviceId)
                $RequestParams = @{
                    Resource = $Resource
                    QSCollection = $QSCollection
                }
                $DeviceOSPatchInstallResults = New-NinjaOneGETRequest @RequestParams
                return $DeviceOSPatchInstallResults
            } else {
                throw ('Device with id {0} not found.' -f $deviceId)
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}