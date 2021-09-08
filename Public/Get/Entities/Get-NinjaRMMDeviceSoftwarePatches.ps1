#Requires -Version 7
function Get-NinjaRMMDeviceSoftwarePatches {
    <#
        .SYNOPSIS
            Gets device Software patches from the NinjaRMM API.
        .DESCRIPTION
            Retrieves device Software patches from the NinjaRMM v2 API.
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
        # Filter patches by product identifier.
        [string]$productIdentifier,
        # Filter patches by type.
        [ValidateSet('PATCH', 'INSTALLER')]
        [String]$type,
        # Filter patches by impact.
        [ValidateSet('OPTIONAL', 'RECOMMENDED', 'CRITICAL')]
        [String]$impact
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
                Write-Verbose "Retrieving software patches for $($Device.SystemName)."
                $Resource = "v2/device/$($deviceID)/software-patches"
            }
        }
        $RequestParams = @{
            Method = 'GET'
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $DeviceSoftwarePatchResults = New-NinjaRMMGETRequest @RequestParams
        Return $DeviceSoftwarePatchResults
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