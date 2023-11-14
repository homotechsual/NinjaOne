
function Get-NinjaOneSoftwareProducts {
    <#
        .SYNOPSIS
            Gets software products from the NinjaOne API.
        .DESCRIPTION
            Retrieves software products from the NinjaOne v2 API.
        .FUNCTIONALITY
            Software Products
        .EXAMPLE
            PS> Get-NinjaOneSoftwareProducts
            
            Gets all software products.
        .EXAMPLE
            PS> Get-NinjaOneSoftwareProducts -deviceId 1

            Gets all software products for the device with ID 1.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param()
    # $CommandName = $MyInvocation.InvocationName
    # $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'deviceid=' parameter by removing it from the set parameters.
    try {
        # $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        Write-Verbose 'Retrieving all software products.'
        $Resource = 'v2/software-products'
        $RequestParams = @{
            Resource = $Resource
            # QSCollection = $QSCollection
        }
        $SoftwareProductResults = New-NinjaOneGETRequest @RequestParams
        Return $SoftwareProductResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}