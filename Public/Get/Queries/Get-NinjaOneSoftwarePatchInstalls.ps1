function Get-NinjaOneSoftwarePatchInstalls {
    <#
        .SYNOPSIS
            Gets the software patch installs from the NinjaOne API.
        .DESCRIPTION
            Retrieves the software patch installs from the NinjaOne v2 API.
        .FUNCTIONALITY
            Software Patch Installs Query
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
        [Parameter(Position = 2, ValueFromPipelineByPropertyName)]
        [ValidateSet('PATCH', 'INSTALLER')]
        [String]$type,
        # Filter patches by impact.
        [Parameter(Position = 3, ValueFromPipelineByPropertyName)]
        [ValidateSet('OPTIONAL', 'RECOMMENDED', 'CRITICAL')]
        [String]$impact,
        # Filter patches by patch status.
        [Parameter(Position = 4, ValueFromPipelineByPropertyName)]
        [ValidateSet('FAILED', 'INSTALLED')]
        [String]$status,
        # Filter patches by product identifier.
        [Parameter(Position = 5, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [String]$productIdentifier,
        # Filter patches to those installed before this date. PowerShell DateTime object.
        [Parameter(Position = 6)]
        [DateTime]$installedBefore,
        # Filter patches to those installed after this date. Unix Epoch time.
        [Parameter(Position = 6)]
        [Int]$installedBeforeUnixEpoch,
        # Filter patches to those installed after this date. PowerShell DateTime object.
        [Parameter(Position = 7)]
        [DateTime]$installedAfter,
        # Filter patches to those installed after this date. Unix Epoch time.
        [Parameter(Position = 7)]
        [Int]$installedAfterUnixEpoch,
        # Cursor name.
        [Parameter(Position = 8)]
        [String]$cursor,
        # Number of results per page.
        [Parameter(Position = 9)]
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
        $Resource = 'v2/queries/software-patch-installs'
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $SoftwarePatchInstalls = New-NinjaOneGETRequest @RequestParams
        if ($SoftwarePatchInstalls) {
            return $SoftwarePatchInstalls
        } else {
            throw 'No software patch installs found.'
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}