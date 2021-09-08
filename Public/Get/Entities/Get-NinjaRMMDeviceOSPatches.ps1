#Requires -Version 7
function Get-NinjaRMMDeviceOSPatches {
    <#
        .SYNOPSIS
            Gets device OS patches from the NinjaRMM API.
        .DESCRIPTION
            Retrieves device OS patches from the NinjaRMM v2 API.
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
        $QSCollection = New-NinjaRMMQuery -CommandName $CommandName -Parameters $Parameters
        if ($deviceID) {
            Write-Verbose 'Getting device from NinjaRMM API.'
            $Device = Get-NinjaRMMDevices -deviceID $deviceID
            if ($Device) {
                Write-Verbose "Retrieving OS patches for $($Device.SystemName)."
                $Resource = "v2/device/$($deviceID)/os-patches"
            }
        }
        $RequestParams = @{
            Method = 'GET'
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $DeviceOSPatchResults = New-NinjaRMMGETRequest @RequestParams
        Return $DeviceOSPatchResults
    } catch {
        $ErrorRecord = @{
            ExceptionType = 'System.Exception'
            ErrorRecord = $_
            ErrorCategory = 'ReadError'
            BubbleUpDetails = $True
            CommandName = $CommandName
        }
        New-NinjaRMMError @ErrorRecord
    }
}