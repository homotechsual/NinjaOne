function Get-NinjaOneOperatingSystems {
    <#
        .SYNOPSIS
            Gets the operating systems from the NinjaOne API.
        .DESCRIPTION
            Retrieves the operating systems from the NinjaOne v2 API.
        .FUNCTIONALITY
            Operating Systems Query
        .EXAMPLE
            PS> Get-NinjaOneOperatingSystems
 
            Gets all operating systems.
        .EXAMPLE
            PS> Get-NinjaOneOperatingSystems -deviceFilter 'org = 1'
 
            Gets the operating systems for the organisation with id 1.
        .EXAMPLE
            PS> Get-NinjaOneOperatingSystems -timeStamp 1619712000

            Gets the operating systems with a monitoring timestamp at or after 1619712000.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Filter devices.
        [Alias('df')]
        [String]$deviceFilter,
        # Monitoring timestamp filter.
        [Alias('ts')]
        [DateTime]$timeStamp,
        # Monitoring timestamp filter in unix time.
        [Int]$timeStampUnix,
        # Cursor name.
        [String]$cursor,
        # Number of results per page.
        [Int]$pageSize
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # If the [DateTime] parameter $timeStamp is set convert the value to a Unix Epoch.
    if ($timeStamp) {
        [int]$Parameters.timeStamp = ConvertTo-UnixEpoch -DateTime $timeStamp
    }
    # If the Unix Epoch parameter $timeStampUnixEpoch is set assign the value to the $timeStamp variable and null $timeStampUnixEpoch.
    if ($timeStampUnixEpoch) {
        [int]$Parameters.timeStamp = $timeStampUnixEpoch
    }
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = 'v2/queries/operating-systems'
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $OperatingSystems = New-NinjaOneGETRequest @RequestParams
        Return $OperatingSystems
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}