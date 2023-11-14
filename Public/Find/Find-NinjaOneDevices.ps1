using namespace System.Management.Automation

function Find-NinjaOneDevices {
    <#
        .SYNOPSIS
            Searches for devices from the NinjaOne API.
        .DESCRIPTION
            Retrieves devices from the NinjaOne v2 API matching a search string. Cannot be used with client credentials authentication at present.
        .FUNCTIONALITY
            Devices
        .EXAMPLE
            PS> Find-NinjaOneDevices -limit 10 -searchQuery 'ABCD'

            Returns an object containing the query and matching devices. Raw data return
        .EXAMPLE
            PS> (Find-NinjaOneDevices -limit 10 -searchQuery 'ABCD').devices

            Returns an array of device objects matching the query.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/find/find-ninjaonedevices
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Limit number of devices to return.
        [Int]$limit,
        # Search query
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [Alias('q')]
        [String]$searchQuery
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        Write-Verbose ('Searching for upto {0} devices matching {1}.') -f $limit, $searchQuery
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = 'v2/devices/search'
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $DeviceSearchResults = New-NinjaOneGETRequest @RequestParams
        Return $DeviceSearchResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}