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
        .EXAMPLE
            PS> Get-NinjaOneOperatingSystems | Group-Object -Property 'name'

            Gets all operating systems grouped by the name property.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/operatingsystemsquery
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Alias('gnoos')]
    [MetadataAttribute(
        '/v2/queries/operating-systems',
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
            $Resource = 'v2/queries/operating-systems'
            $RequestParams = @{
                Resource = $Resource
                QSCollection = $QSCollection
            }
            $OperatingSystems = New-NinjaOneGETRequest @RequestParams
            if ($OperatingSystems) {
                return $OperatingSystems
            } else {
                throw 'No operating systems found.'
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}