function Get-NinjaOneSoftwarePatchInstalls {
    <#
        .SYNOPSIS
            Gets the software patch installs from the NinjaOne API.
        .DESCRIPTION
            Retrieves the software patch installs from the NinjaOne v2 API.
        .EXAMPLE
            PS> Get-NinjaOneSoftwarePatchInstalls

            Gets all software patch installs.
        .EXAMPLE
            PS> Get-NinjaOneSoftwarePatchInstalls -deviceFilter 'org = 1'

            Gets the software patch installs for the organisation with id 1.
        .EXAMPLE
            PS> Get-NinjaOneSoftwarePatchInstalls -timeStamp 1619712000

            Gets the software patch installs with a monitoring timestamp at or after 1619712000.
        .EXAMPLE
            PS> Get-NinjaOneSoftwarePatchInstalls -type 'PATCH'

            Gets the software patch installs with a type of 'PATCH'.
        .EXAMPLE
            PS> Get-NinjaOneSoftwarePatchInstalls -impact 'OPTIONAL'

            Gets the software patch installs with an impact of 'OPTIONAL'.
        .EXAMPLE
            Get-NinjaOneSoftwarePatchInstalls -status 'FAILED'

            Gets the software patch installs with a status of 'FAILED'.
        .EXAMPLE
            PS> Get-NinjaOneSoftwarePatchInstalls -productIdentifier 23e4567-e89b-12d3-a456-426614174000

            Gets the software patch installs with a product identifier of '23e4567-e89b-12d3-a456-426614174000'.
        .EXAMPLE
            PS> Get-NinjaOneSoftwarePatchInstalls -installedBefore (Get-Date)

            Gets the software patch installs installed before the current date.
        .EXAMPLE
            PS> Get-NinjaOneSoftwarePatchInstalls -installedBeforeUnixEpoch 1619712000

            Gets the software patch installs installed before 1619712000.
        .EXAMPLE
            PS> Get-NinjaOneSoftwarePatchInstalls -installedAfter (Get-Date)

            Gets the software patch installs installed after the current date.
        .EXAMPLE
            PS> Get-NinjaOneSoftwarePatchInstalls -installedAfterUnixEpoch 1619712000

            Gets the software patch installs installed after 1619712000.
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
        [ValidateSet('PATCH', 'INSTALLER')]
        [string]$type,
        # Filter patches by impact.
        [ValidateSet('OPTIONAL', 'RECOMMENDED', 'CRITICAL')]
        [string]$impact,
        # Filter patches by patch status.
        [ValidateSet('FAILED', 'INSTALLED')]
        [String]$status,
        # Filter patches by product identifier.
        [String]$productIdentifier,
        # Filter patches to those installed before this date. PowerShell DateTime object.
        [DateTime]$installedBefore,
        # Filter patches to those installed after this date. Unix Epoch time.
        [Int]$installedBeforeUnixEpoch,
        # Filter patches to those installed after this date. PowerShell DateTime object.
        [DateTime]$installedAfter,
        # Filter patches to those installed after this date. Unix Epoch time.
        [Int]$installedAfterUnixEpoch,
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
        $Resource = 'v2/queries/software-patch-installs'
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $SoftwarePatchInstalls = New-NinjaOneGETRequest @RequestParams
        Return $SoftwarePatchInstalls
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}