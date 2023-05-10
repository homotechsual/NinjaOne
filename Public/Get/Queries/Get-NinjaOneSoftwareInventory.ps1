function Get-NinjaOneSoftwareInventory {
    <#
        .SYNOPSIS
            Gets the software inventory from the NinjaOne API.
        .DESCRIPTION
            Retrieves the software inventory from the NinjaOne v2 API.
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