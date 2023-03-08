
function Get-NinjaOneDeviceOSPatches {
    <#
        .SYNOPSIS
            Gets device OS patches from the NinjaOne API.
        .DESCRIPTION
            Retrieves device OS patches from the NinjaOne v2 API. If you want patch information for multiple devices please check out the related 'queries' commandlet `Get-NinjaOneOSPatches`.
        .EXAMPLE
            PS> Get-NinjaOneDeviceOSPatches -deviceId 1

            Gets OS patch information for the device with id 1.
        .EXAMPLE
            PS> Get-NinjaOneDeviceOSPatches -deviceId 1 -status 'APPROVED' -type 'SECURITY_UPDATES' -severity 'CRITICAL'

            Gets OS patch information for the device with id 1 where the patch is an approved security update with critical severity.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Device id to get OS patch information for.
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        [Alias('id')]
        [Int]$deviceId,
        # Filter returned patches by patch status.
        [ValidateSet('MANUAL', 'APPROVED', 'FAILED', 'REJECTED')]
        [String[]]$status,
        # Filter returned patches by type.
        [ValidateSet('UPDATE_ROLLUPS', 'SECURITY_UPDATES', 'DEFINITION_UPDATES', 'CRITICAL_UPDATES', 'REGULAR_UPDATES', 'FEATURE_PACKS', 'DRIVER_UPDATES')]
        [String[]]$type,
        # Filter returned patches by severity.
        [ValidateSet('OPTIONAL', 'MODERATE', 'IMPORTANT', 'CRITICAL')]
        [String[]]$severity
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
                Write-Verbose "Retrieving OS patches for $($Device.SystemName)."
                $Resource = "v2/device/$($deviceId)/os-patches"
            }
        }
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $DeviceOSPatchResults = New-NinjaOneGETRequest @RequestParams
        Return $DeviceOSPatchResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}