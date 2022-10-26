#Requires -Version 7
function Get-NinjaOneDeviceSoftwarePatches {
    <#
        .SYNOPSIS
            Gets device Software patches from the NinjaOne API.
        .DESCRIPTION
            Retrieves device Software patches from the NinjaOne v2 API. If you want patch information for multiple devices please check out the related 'queries' commandlet `Get-NinjaOneSoftwarePatches`.
        .EXAMPLE
            PS> Get-NinjaOneDeviceSoftwarePatches -deviceId 1

            Gets all software patches for the device with id 1.
        .EXAMPLE
            PS> Get-NinjaOneDeviceSoftwarePatches -deviceId 1 -status 'APPROVED' -type 'PATCH' -impact 'CRITICAL'

            Gets all software patches for the device with id 1 where the patch is approved, has type patch and has critical impact/severity.
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
    if ($deviceId) {
        $Parameters.Remove('deviceId') | Out-Null
    }
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        if ($deviceId) {
            Write-Verbose 'Getting device from NinjaOne API.'
            $Device = Get-NinjaOneDevices -deviceId $deviceId
            if ($Device) {
                Write-Verbose "Retrieving software patches for $($Device.SystemName)."
                $Resource = "v2/device/$($deviceId)/software-patches"
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