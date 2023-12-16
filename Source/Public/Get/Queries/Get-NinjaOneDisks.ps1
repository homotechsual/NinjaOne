function Get-NinjaOneDisks {
    <#
        .SYNOPSIS
            Gets the disks from the NinjaOne API.
        .DESCRIPTION
            Retrieves the disks from the NinjaOne v2 API.
        .FUNCTIONALITY
            Disks Query
        .EXAMPLE
            PS> Get-NinjaOneDisks

            Gets all disks.
        .EXAMPLE
            PS> Get-NinjaOneDisks -deviceFilter 'org = 1'

            Gets the disks for the organisation with id 1.
        .EXAMPLE
            PS> Get-NinjaOneDisks -timeStamp 1619712000

            Gets the disks with a monitoring timestamp at or after 1619712000.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/disksquery
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Alias('gnodi')]
    [Metadata(
        '/v2/queries/disks',
        'get'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Filter devices.
        [Parameter(Position = 0)]
        [Alias('df')]
        [String]$deviceFilter,
        # Monitoring timestamp filter.
        [Parameter(Position = 1)]
        [Alias('ts')]
        [DateTime]$timeStamp,
        # Monitoring timestamp filter in unix time.
        [Parameter(Position = 1)]
        [Int]$timeStampUnixEpoch,
        # Cursor name.
        [Parameter(Position = 2)]
        [String]$cursor,
        # Number of results per page.
        [Parameter(Position = 3)]
        [Int]$pageSize
    )
    begin {
        $CommandName = $MyInvocation.InvocationName
        $Parameters = (Get-Command -Name $CommandName).Parameters
        # If the [DateTime] parameter $timeStamp is set convert the value to a Unix Epoch.
        if ($timeStamp) {
            [int]$timeStamp = ConvertTo-UnixEpoch -DateTime $timeStamp
        }
        # If the Unix Epoch parameter $timeStampUnixEpoch is set assign the value to the $timeStamp variable and null $timeStampUnixEpoch.
        if ($timeStampUnixEpoch) {
            $Parameters.Remove('timeStampUnixEpoch') | Out-Null
            [int]$timeStamp = $timeStampUnixEpoch
        }
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
    }
    process {
        try {
            $Resource = 'v2/queries/disks'
            $RequestParams = @{
                Resource = $Resource
                QSCollection = $QSCollection
            }
            $Disks = New-NinjaOneGETRequest @RequestParams
            if ($Disks) {
                return $Disks
            } else {
                throw 'No disks found.'
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}