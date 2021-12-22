#Requires -Version 7
function Get-NinjaOneDeviceDashboardURL {
    <#
        .SYNOPSIS
            Gets device dashboard URL from the NinjaOne API.
        .DESCRIPTION
            Retrieves device dashboard URL from the NinjaOne v2 API.
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
        # Return redirect response.
        [Switch]$redirect
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
                Write-Verbose "Retrieving dashboard URL for $($Device.SystemName)."
                $Resource = "v2/device/$($deviceID)/dashboard-url"
            }
        }
        $RequestParams = @{
            Method = 'GET'
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $DeviceDashboardURLResults = New-NinjaOneGETRequest @RequestParams
        Return $DeviceDashboardURLResults
    } catch {
        $ErrorRecord = @{
            ExceptionType = 'System.Exception'
            ErrorRecord = $_
            ErrorCategory = 'ReadError'
            BubbleUpDetails = $True
            CommandName = $CommandName
        }
        New-NinjaOneError @ErrorRecord
    }
}