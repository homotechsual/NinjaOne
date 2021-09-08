#Requires -Version 7
function Get-NinjaRMMDeviceSoftwarePatchInstalls {
    <#
        .SYNOPSIS
            Gets device software patch installs from the NinjaRMM API.
        .DESCRIPTION
            Retrieves device software patch installs from the NinjaRMM v2 API.
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
        # Filter patches to those installed before this date.
        [DateTime]$installedBefore,
        # Filter patches to those installed after this date.
        [DateTime]$installedAfter
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
                Write-Verbose "Retrieving software patch installs for $($Device.SystemName)."
                $Resource = "v2/device/$($deviceID)/software-patch-installs"
            }
        }
        $RequestParams = @{
            Method = 'GET'
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $DeviceSoftwarePatchIntallResults = New-NinjaRMMGETRequest @RequestParams
        Return $DeviceSoftwarePatchIntallResults
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