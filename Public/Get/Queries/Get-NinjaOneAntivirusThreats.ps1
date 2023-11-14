function Get-NinjaOneAntivirusThreats {
    <#
        .SYNOPSIS
            Gets the antivirus threats from the NinjaOne API.
        .DESCRIPTION
            Retrieves the antivirus threats from the NinjaOne v2 API.
        .FUNCTIONALITY
            Antivirus Threats Query
        .EXAMPLE
            PS> Get-NinjaOneAntivirusThreats

            Gets the antivirus threats.
        .EXAMPLE
            PS> Get-NinjaOneAntivirusThreats -deviceFilter 'org = 1'

            Gets the antivirus threats for the organisation with id 1.
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
        [int]$timeStampUnixEpoch,
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
        $Resource = 'v2/queries/antivirus-threats'
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $AntivirusThreats = New-NinjaOneGETRequest @RequestParams
        Return $AntivirusThreats
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}