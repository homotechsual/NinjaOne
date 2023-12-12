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

            returns an object containing the query and matching devices. Raw data return
        .EXAMPLE
            PS> (Find-NinjaOneDevices -limit 10 -searchQuery 'ABCD').devices

            returns an array of device objects matching the query.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Find/devices
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Alias('fnod', 'Find-NinjaOneDevice')]
    [Metadata(
        '/v2/devices/search',
        'get'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Limit number of devices to return.
        [Int]$limit,
        # Search query
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [Alias('q')]
        [String]$searchQuery
    )
    begin {
        $CommandName = $MyInvocation.InvocationName
        $Parameters = (Get-Command -Name $CommandName).Parameters
    }
    process {
        try {
            Write-Verbose ('Searching for upto {0} devices matching {1}.') -f $limit, $searchQuery
            $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
            $Resource = 'v2/devices/search'
            $RequestParams = @{
                Resource = $Resource
                QSCollection = $QSCollection
            }
            $DeviceSearchResults = New-NinjaOneGETRequest @RequestParams
            return $DeviceSearchResults
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}