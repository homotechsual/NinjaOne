
function Get-NinjaOneDeviceDashboardURL {
    <#
        .SYNOPSIS
            Gets device dashboard URL from the NinjaOne API.
        .DESCRIPTION
            Retrieves device dashboard URL from the NinjaOne v2 API.
        .EXAMPLE
            PS> Get-NinjaOneDeviceDashboardURL -deviceId 1

            Gets the device dashboard URL for the device with ID 1.
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
        # Return redirect response. This is largely useless as it will return a HTML redirect page source.
        [Switch]$redirect
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
                Write-Verbose "Retrieving dashboard URL for $($Device.SystemName)."
                $Resource = "v2/device/$($deviceId)/dashboard-url"
            }
        }
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        if ($redirect) {
            $RequestParams.Add('Raw', $true)
        }
        $DeviceDashboardURLResults = New-NinjaOneGETRequest @RequestParams
        Return $DeviceDashboardURLResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}