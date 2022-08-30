using namespace System.Management.Automation
#Requires -Version 7
function Find-NinjaOneDevices {
    <#
        .SYNOPSIS
            Searches for devices from the NinjaOne API.
        .DESCRIPTION
            Retrieves devices from the NinjaOne v2 API matching a search string.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Limit number of devices to return.
        [Int]$limit,
        # Search query
        [Parameter( Mandatory = $True )]
        [Alias('q')]
        [String]$searchQuery
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        Write-Verbose "Searching for upto $($Limit) devices matching $($Query)"
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