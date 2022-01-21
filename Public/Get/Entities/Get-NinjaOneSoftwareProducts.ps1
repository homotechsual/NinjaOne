#Requires -Version 7
function Get-NinjaOneSoftwareProducts {
    <#
        .SYNOPSIS
            Gets software products from the NinjaOne API.
        .DESCRIPTION
            Retrieves software products from the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( DefaultParameterSetName = 'Multi' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Device ID
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [Int]$deviceID
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        if ($deviceID) {
            Write-Verbose 'Getting device from NinjaOne API.'
            $Device = Get-NinjaOneDevices -deviceID $deviceID
            if ($Device) {
                Write-Verbose "Retrieving software products for $($Device.SystemName)."
                $Resource = "v2/device/$($deviceID)/software"
            }
        } else {
            Write-Verbose 'Retrieving all software products.'
            $Resource = 'v2/software-products'
        }
        $RequestParams = @{
            Method = 'GET'
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $SoftwareProductResults = New-NinjaOneGETRequest @RequestParams
        Return $SoftwareProductResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}