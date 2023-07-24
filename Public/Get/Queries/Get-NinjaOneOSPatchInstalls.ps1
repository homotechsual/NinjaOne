function Get-NinjaOneOSPatchInstalls {
    <#
        .SYNOPSIS
            Gets the OS patch installs from the NinjaOne API.
        .DESCRIPTION
            Retrieves the OS patch installs from the NinjaOne v2 API.
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
        [string]$timeStamp,
        # Filter patches by patch status.
        [ValidateSet('FAILED', 'INSTALLED')]
        [String]$status,
        # Filter patches to those installed before this date. 
        [DateTime]$installedBefore,
        # Filter patches to those installed after this date. Unix Epoch time.
        [Int]$installedBeforeUnixEpoch,
        # Filter patches to those installed after this date. PowerShell DateTime object.
        [DateTime]$installedAfter,
        # Filter patches to those installed after this date. Unix Epoch time.
        [Int]$installedAfterUnixEpoch,
        # Cursor name.
        [String]$cursor,
        # Number of results per page.
        [Int]$pageSize
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    if ($installedBefore) {
        [Int]$installedBefore = ConvertTo-UnixEpoch -DateTime $installedBefore
    }
    if ($installedBeforeUnixEpoch) {
        $Parameters.Remove('installedBeforeUnixEpoch') | Out-Null
        [Int]$installedBefore = $installedBeforeUnixEpoch
    }
    if ($installedAfter) {
        [Int]$installedAfter = ConvertTo-UnixEpoch -DateTime $installedAfter
    }
    if ($installedAfterUnixEpoch) {
        $Parameters.Remove('installedAfterUnixEpoch') | Out-Null
        [Int]$installedAfter = $installedAfterUnixEpoch
    }
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = 'v2/queries/os-patch-installs'
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $OSPatchInstalls = New-NinjaOneGETRequest @RequestParams
        Return $OSPatchInstalls
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}