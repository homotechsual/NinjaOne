function Get-NinjaOneVolumes {
    <#
        .SYNOPSIS
            Gets the volumes from the NinjaOne API.
        .DESCRIPTION
            Retrieves the volumes from the NinjaOne v2 API.
        .FUNCTIONALITY
            Volumes Query
        .EXAMPLE
            PS> Get-NinjaOneVolumes

            Gets all volumes.
        .EXAMPLE
            PS> Get-NinjaOneVolumes -deviceFilter 'org = 1'

            Gets the volumes for the organisation with id 1.
        .EXAMPLE
            PS> Get-NinjaOneVolumes -timeStamp 1619712000

            Gets the volumes with a monitoring timestamp at or after 1619712000.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/volumesquery
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Filter devices.
        [Parameter(Position = 0)]
        [Alias('df')]
        [String]$deviceFilter,
        # Monitoring timestamp filter. PowerShell DateTime object.
        [Parameter(Position = 1)]
        [Alias('ts')]
        [DateTime]$timeStamp,
        # Monitoring timestamp filter. Unix Epoch time.
        [Parameter(Position = 1)]
        [Int]$timeStampUnixEpoch,
        # Cursor name.
        [Parameter(Position = 2)]
        [String]$cursor,
        # Number of results per page.
        [Parameter(Position = 3)]
        [Int]$pageSize
    )
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
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = 'v2/queries/volumes'
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $Volumes = New-NinjaOneGETRequest @RequestParams
        if ($Volumes) {
            return $Volumes
        } else {
            throw 'No volumes found.'
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}