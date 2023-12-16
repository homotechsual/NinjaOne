
function Get-NinjaOneDeviceDashboardURL {
    <#
        .SYNOPSIS
            Gets device dashboard URL from the NinjaOne API.
        .DESCRIPTION
            Retrieves device dashboard URL from the NinjaOne v2 API.
        .FUNCTIONALITY
            Device Dashboard URL
        .EXAMPLE
            PS> Get-NinjaOneDeviceDashboardURL -deviceId 1

            Gets the device dashboard URL for the device with id 1.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicedashboardurl
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Alias('gnoddurl')]
    [Metadata(
        '/v2/device/{id}/dashboard-url',
        'get'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The device id to get the dashboard URL for.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [Int]$deviceId,
        # return redirect response. This is largely useless as it will return a HTML redirect page source.
        [Parameter(Position = 1)]
        [Switch]$redirect
    )
    begin {
        $CommandName = $MyInvocation.InvocationName
        $Parameters = (Get-Command -Name $CommandName).Parameters
        # Workaround to prevent the query string processor from adding an 'deviceid=' parameter by removing it from the set parameters.
        $Parameters.Remove('deviceId') | Out-Null
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
    }
    process {
        try {
            Write-Verbose 'Getting device from NinjaOne API.'
            $Device = Get-NinjaOneDevices -deviceId $deviceId
            if ($Device) {
                Write-Verbose ('Getting dashboard URL for device {0}.' -f $Device.SystemName)
                $Resource = ('v2/device/{0}/dashboard-url' -f $deviceId)
            }
            $RequestParams = @{
                Resource = $Resource
                QSCollection = $QSCollection
            }
            if ($redirect) {
                $RequestParams.Add('Raw', $true)
            }
            $DeviceDashboardURLResults = New-NinjaOneGETRequest @RequestParams
            if ($DeviceDashboardURLResults) {
                return $DeviceDashboardURLResults
            } else {
                throw ('No dashboard URL found for device {0}.' -f $Device.SystemName)
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}