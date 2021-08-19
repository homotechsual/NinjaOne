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
        [Parameter(Mandatory = $True)]
        [Int]$deviceID,
        # Filter patches by patch status.
        [String]$status,
        # Filter patches by product identifier.
        [string]$productIdentifier,
        # Filter patches by type.
        [String]$type,
        # Filter patches by impact.
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
            $Device = Get-NinjaRMMDevices -deviceID $deviceID -ErrorAction SilentlyContinue
            if ($Device) {
                Write-Verbose "Retrieving software patches for $($Device.SystemName)."
                $Resource = "v2/device/$($deviceID)/software-patches"
            } else {
                $GroupNotFoundError = [ErrorRecord]::New(
                    [ItemNotFoundException]::new("Device with ID $($deviceID) was not found in NinjaRMM."),
                    'NinjaDeviceNotFound',
                    'ObjectNotFound',
                    $deviceID
                )
                $PSCmdlet.ThrowTerminatingError($GroupNotFoundError)
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
        $CommandFailedError = [ErrorRecord]::New(
            [System.Exception]::New(
                'Failed to get device software patches from NinjaRMM. You can use "Get-Error" for detailed error information.',
                $_.Exception
            ),
            'NinjaCommandFailed',
            'ReadError',
            $TargetObject
        )
        $PSCmdlet.ThrowTerminatingError($CommandFailedError)
    }
}