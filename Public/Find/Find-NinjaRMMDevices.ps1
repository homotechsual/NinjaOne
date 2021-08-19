using namespace System.Management.Automation
#Requires -Version 7
function Find-NinjaRMMDevices {
    <#
        .SYNOPSIS
            Searches for devices from the NinjaRMM API.
        .DESCRIPTION
            Retrieves devices from the NinjaRMM v2 API matching a search string.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Search query
        [Parameter( Mandatory = $True )]
        [Alias('q')]
        [String]$query,
        # Limit number of devices to return.
        [Int]$limit
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        Write-Verbose "Searching for upto $($Limit) devices matching $($Query)"
        $QSCollection = New-NinjaRMMQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = 'v2/devices/search'
        $RequestParams = @{
            Method = 'GET'
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $DeviceSearchResults = New-NinjaRMMGETRequest @RequestParams
        Return $DeviceSearchResults
    } catch {
        $CommandFailedError = [ErrorRecord]::New(
            [System.Exception]::New(
                'The NinjaRMM device search failed. You can use "Get-Error" for detailed error information.',
                $_.Exception
            ),
            'NinjaRequestFailed',
            'ReadError',
            $TargetObject
        )
        $PSCmdlet.ThrowTerminatingError($CommandFailedError)
    }
}