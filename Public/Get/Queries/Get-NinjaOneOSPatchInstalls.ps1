function Get-NinjaOneOSPatchInstalls {
    <#
        .SYNOPSIS
            Gets the OS patch installs from the NinjaOne API.
        .DESCRIPTION
            Retrieves the OS patch installs from the NinjaOne v2 API.
        .FUNCTIONALITY
            OS Patch Installs Query
        .EXAMPLE
            PS> Get-NinjaOneOSPatchInstalls

            Gets all OS patch installs.
        .EXAMPLE
            PS> Get-NinjaOneOSPatchInstalls -deviceFilter 'org = 1'

            Gets the OS patch installs for the organisation with id 1.
        .EXAMPLE
            PS> Get-NinjaOneOSPatchInstalls -timeStamp 1619712000

            Gets the OS patch installs with a monitoring timestamp at or after 1619712000.
        .EXAMPLE
            PS> Get-NinjaOneOSPatchInstalls -status 'FAILED'

            Gets the OS patch installs with a status of 'FAILED'.
        .EXAMPLE
            PS> Get-NinjaOneOSPatchInstalls -installedBefore (Get-Date)

            Gets the OS patch installs installed before the current date.
        .EXAMPLE
            PS> Get-NinjaOneOSPatchInstalls -installedBeforeUnixEpoch 1619712000

            Gets the OS patch installs installed before 1619712000.
        .EXAMPLE
            PS> Get-NinjaOneOSPatchInstalls -installedAfter (Get-Date).AddDays(-1)

            Gets the OS patch installs installed after the previous day.
        .EXAMPLE
            PS> Get-NinjaOneOSPatchInstalls -installedAfterUnixEpoch 1619712000

            Gets the OS patch installs installed after 1619712000.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/ospatchinstallsquery
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
        # Filter patches by patch status.
        [Parameter(Position = 2, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateSet('FAILED', 'INSTALLED')]
        [String]$status,
        # Filter patches to those installed before this date.
        [Parameter(Position = 3)] 
        [DateTime]$installedBefore,
        # Filter patches to those installed after this date. Unix Epoch time.
        [Parameter(Position = 3)]
        [Int]$installedBeforeUnixEpoch,
        # Filter patches to those installed after this date. PowerShell DateTime object.
        [Parameter(Position = 4)]
        [DateTime]$installedAfter,
        # Filter patches to those installed after this date. Unix Epoch time.
        [Parameter(Position = 4)]
        [Int]$installedAfterUnixEpoch,
        # Cursor name.
        [Parameter(Position = 5)]
        [String]$cursor,
        # Number of results per page.
        [Parameter(Position = 6)]
        [Int]$pageSize
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # If the [DateTime] parameter $installedBefore is set convert the value to a Unix Epoch.
    if ($installedBefore) {
        [Int]$installedBefore = ConvertTo-UnixEpoch -DateTime $installedBefore
    }
    # If the Unix Epoch parameter $installedBeforeUnixEpoch is set assign the value to the $installedBefore variable and null $installedBeforeUnixEpoch.
    if ($installedBeforeUnixEpoch) {
        $Parameters.Remove('installedBeforeUnixEpoch') | Out-Null
        [Int]$installedBefore = $installedBeforeUnixEpoch
    }
    # If the [DateTime] parameter $installedAfter is set convert the value to a Unix Epoch.
    if ($installedAfter) {
        [Int]$installedAfter = ConvertTo-UnixEpoch -DateTime $installedAfter
    }
    # If the Unix Epoch parameter $installedAfterUnixEpoch is set assign the value to the $installedAfter variable and null $installedAfterUnixEpoch.
    if ($installedAfterUnixEpoch) {
        $Parameters.Remove('installedAfterUnixEpoch') | Out-Null
        [Int]$installedAfter = $installedAfterUnixEpoch
    }
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
        $Resource = 'v2/queries/os-patch-installs'
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $OSPatchInstalls = New-NinjaOneGETRequest @RequestParams
        if ($OSPatchInstalls) {
            return $OSPatchInstalls
        } else {
            throw 'No OS patch installs found.'
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}