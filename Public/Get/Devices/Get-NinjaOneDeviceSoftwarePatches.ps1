#Requires -Version 7
function Get-NinjaOneDeviceSoftwarePatches {
    <#
        .SYNOPSIS
            Gets device Software patches from the NinjaOne API.
        .DESCRIPTION
            Retrieves device Software patches from the NinjaOne v2 API.
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
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        if ($deviceID) {
            Write-Verbose 'Getting device from NinjaOne API.'
            $Device = Get-NinjaOneDevices -deviceID $deviceID
            if ($Device) {
                Write-Verbose "Retrieving software patches for $($Device.SystemName)."
                $Resource = "v2/device/$($deviceID)/software-patches"
            }
        }
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $DeviceSoftwarePatchResults = New-NinjaOneGETRequest @RequestParams
        Return $DeviceSoftwarePatchResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}