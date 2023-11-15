
function Get-NinjaOneSoftwareProducts {
    <#
        .SYNOPSIS
            Gets software products for a device from the NinjaOne API.
        .DESCRIPTION
            Retrieves software products for a device from the NinjaOne v2 API.
        .FUNCTIONALITY
            Device Software Products
        .EXAMPLE
            PS> Get-NinjaOneSoftwareProducts -deviceId 1

            Gets all software products for the device with id 1.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The device id to get software products for.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [Int]$deviceId
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'deviceid=' parameter by removing it from the set parameters.
    $Parameters.Remove('deviceId') | Out-Null
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        Write-Verbose 'Getting device from NinjaOne API.'
        $Device = Get-NinjaOneDevices -deviceId $deviceId
        if ($Device) {
            Write-Verbose ('Getting software products for device {0}.' -f $Device.SystemName)
            $Resource = ('v2/device/{0}/software' -f $deviceId)
        } else {
            throw ('Device with id {0} not found.' -f $deviceId)
        }
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $SoftwareProductResults = New-NinjaOneGETRequest @RequestParams
        return $SoftwareProductResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}