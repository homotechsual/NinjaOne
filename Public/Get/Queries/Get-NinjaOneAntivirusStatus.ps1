function Get-NinjaOneAntivirusStatus {
    <#
        .SYNOPSIS
            Gets the antivirus status from the NinjaOne API.
        .DESCRIPTION
            Retrieves the antivirus status from the NinjaOne v2 API.
        .FUNCTIONALITY
            Antivirus Status Query
        .EXAMPLE
            PS> Get-NinjaOneAntivirusStatus -deviceFilter 'org = 1'

            Gets the antivirus status for the organisation with id 1.
        .EXAMPLE
            PS> Get-NinjaOneAntivirusStatus -timeStamp 1619712000

            Gets the antivirus status at or after the timestamp 1619712000.
        .EXAMPLE
            PS> Get-NinjaOneAntivirusStatus -productState 'ON'

            Gets the antivirus status where the product state is ON.
        .EXAMPLE
            PS> Get-NinjaOneAntivirusStatus -productName 'Microsoft Defender Antivirus'

            Gets the antivirus status where the antivirus product name is Microsoft Defender Antivirus.
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
        [DatTime]$timeStamp,
        # Monitoring timestamp filter in unix time.
        [int]$timeStampUnix,
        # Filter by product state.
        [String]$productState,
        # Filter by product name.
        [string]$productName,
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
        $Resource = 'v2/queries/antivirus-status'
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $AntivirusStatus = New-NinjaOneGETRequest @RequestParams
        Return $AntivirusStatus
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}