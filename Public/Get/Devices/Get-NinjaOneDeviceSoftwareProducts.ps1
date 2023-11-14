
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

            Gets all software products for the device with ID 1.
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
        $Device = Get-NinjaOneDevices -deviceID $deviceId
        if ($Device) {
            Write-Verbose "Retrieving software products for $($Device.SystemName)."
            $Resource = "v2/device/$($deviceId)/software"
        }
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $SoftwareProductResults = New-NinjaOneGETRequest @RequestParams
        Return $SoftwareProductResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}