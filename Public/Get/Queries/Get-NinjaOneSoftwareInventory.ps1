function Get-NinjaOneSoftwareInventory {
    <#
        .SYNOPSIS
            Gets the software inventory from the NinjaOne API.
        .DESCRIPTION
            Retrieves the software inventory from the NinjaOne v2 API.
        .EXAMPLE
            PS> Get-NinjaOneSoftwareInventory

            Gets the software inventory.
        .EXAMPLE
            PS> Get-NinjaOneSoftwareInventory -deviceFilter 'org = 1'

            Gets the software inventory for the organisation with id 1.
        .EXAMPLE
            PS> Get-NinjaOneSoftwareInventory -installedBefore (Get-Date)

            Gets the software inventory for software installed before the current date.
        .EXAMPLE
            PS> Get-NinjaOneSoftwareInventory -installedBeforeUnixEpoch 1619712000

            Gets the software inventory for software installed before 1619712000.
        .EXAMPLE
            PS> Get-NinjaOneSoftwareInventory -installedAfter (Get-Date).AddDays(-1)

            Gets the software inventory for software installed after the previous day.
        .EXAMPLE
            PS> Get-NinjaOneSoftwareInventory -installedAfterUnixEpoch 1619712000

            Gets the software inventory for software installed after 1619712000.
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
        # Cursor name.
        [String]$cursor,
        # Number of results per page.
        [Int]$pageSize,
        # Filter software to those installed before this date. PowerShell DateTime object.
        [DateTime]$installedBefore,
        # Filter software to those installed after this date. Unix Epoch time.
        [Int]$installedBeforeUnixEpoch,
        # Filter software to those installed after this date. PowerShell DateTime object.
        [DateTime]$installedAfter,
        # Filter software to those installed after this date. Unix Epoch time.
        [Int]$installedAfterUnixEpoch
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
        $Resource = 'v2/queries/software'
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $SoftwareInventory = New-NinjaOneGETRequest @RequestParams
        Return $SoftwareInventory
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}