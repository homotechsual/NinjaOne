function Get-NinjaOneAntiVirusThreats {
    <#
        .SYNOPSIS
            Gets the antivirus threats from the NinjaOne API.
        .DESCRIPTION
            Retrieves the antivirus threats from the NinjaOne v2 API.
        .FUNCTIONALITY
            AntiVirus Threats Query
        .EXAMPLE
            PS> Get-NinjaOneAntivirusThreats

            Gets the antivirus threats.
        .EXAMPLE
            PS> Get-NinjaOneAntivirusThreats -deviceFilter 'org = 1'

            Gets the antivirus threats for the organisation with id 1.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/antivirusthreatsquery
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Alias('gnoavt')]
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
        [int]$timeStampUnixEpoch,
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
            $parameters.Remove('timeStampUnixEpoch') | Out-Null
            [int]$timeStamp = $timeStampUnixEpoch
        }
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
    }
    process {
        try {
            
            $Resource = 'v2/queries/antivirus-threats'
            $RequestParams = @{
                Resource = $Resource
                QSCollection = $QSCollection
            }
            $AntivirusThreats = New-NinjaOneGETRequest @RequestParams
            if ($AntivirusThreats) {
                return $AntivirusThreats
            } else {
                throw 'No antivirus threats found.'
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}