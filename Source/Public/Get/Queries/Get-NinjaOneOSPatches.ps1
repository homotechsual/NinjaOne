function Get-NinjaOneOSPatches {
    <#
        .SYNOPSIS
            Gets the OS patches from the NinjaOne API.
        .DESCRIPTION
            Retrieves the OS patches from the NinjaOne v2 API.
        .FUNCTIONALITY
            OS Patches Query
        .EXAMPLE
            PS> Get-NinjaOneOSPatches

            Gets all OS patches.
        .EXAMPLE
            PS> Get-NinjaOneOSPatches -deviceFilter 'org = 1'

            Gets the OS patches for the organisation with id 1.
        .EXAMPLE
            PS> Get-NinjaOneOSPatches -timeStamp 1619712000

            Gets the OS patches with a monitoring timestamp at or after 1619712000.
        .EXAMPLE
            PS> Get-NinjaOneOSPatches -status 'APPROVED'

            Gets the OS patches with a status of APPROVED.
        .EXAMPLE
            PS> Get-NinjaOneOSPatches -type 'SECURITY_UPDATES'

            Gets the OS patches with a type of SECURITY_UPDATES.
        .EXAMPLE
            PS> Get-NinjaOneOSPatches -severity 'CRITICAL'

            Gets the OS patches with a severity of CRITICAL.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/ospatchesquery
    #>
    [CmdletBinding()]
    [OutputType([Object])]
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
        # Filter patches by patch status.
        [Parameter(Position = 2, ValueFromPipelineByPropertyName)]
        [ValidateSet('MANUAL', 'APPROVED', 'FAILED', 'REJECTED')]
        [String]$status,
        # Filter patches by type.
        [Parameter(Position = 3, ValueFromPipelineByPropertyName)]
        [ValidateSet('UPDATE_ROLLUPS', 'SECURITY_UPDATES', 'DEFINITION_UPDATES', 'CRITICAL_UPDATES', 'REGULAR_UPDATES', 'FEATURE_PACKS', 'DRIVER_UPDATES')]
        [String]$type,
        # Filter patches by severity.
        [Parameter(Position = 4, ValueFromPipelineByPropertyName)]
        [ValidateSet('OPTIONAL', 'MODERATE', 'IMPORTANT', 'CRITICAL')]
        [String]$severity,
        # Cursor name.
        [Parameter(Position = 5)]
        [String]$cursor,
        # Number of results per page.
        [Parameter(Position = 6)]
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
        $Resource = 'v2/queries/os-patches'
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $OSPatches = New-NinjaOneGETRequest @RequestParams
        if ($OSPatches) {
            return $OSPatches
        } else {
            throw 'No OS patches found.'
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}