#Requires -Version 7
function Get-NinjaOneDeviceOSPatches {
    <#
        .SYNOPSIS
            Gets device OS patches from the NinjaOne API.
        .DESCRIPTION
            Retrieves device OS patches from the NinjaOne v2 API.
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
        # Filter patches by patch status.
        [ValidateSet('MANUAL', 'APPROVED', 'FAILED', 'REJECTED')]
        [String]$status,
        # Filter patches by type.
        [ValidateSet('UPDATE_ROLLUPS', 'SECURITY_UPDATES', 'DEFINITION_UPDATES', 'CRITICAL_UPDATES', 'REGULAR_UPDATES', 'FEATURE_PACKS', 'DRIVER_UPDATES')]
        [String]$type,
        # Filter patches by severity.
        [ValidateSet('OPTIONAL', 'MODERATE', 'IMPORTANT', 'CRITICAL')]
        [String]$severity
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
                Write-Verbose "Retrieving OS patches for $($Device.SystemName)."
                $Resource = "v2/device/$($deviceID)/os-patches"
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