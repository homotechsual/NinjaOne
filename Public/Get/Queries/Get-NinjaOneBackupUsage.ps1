function Get-NinjaOneBackupUsage {
    <#
        .SYNOPSIS
            Gets the backup usage by device from the NinjaOne API.
        .DESCRIPTION
            Retrieves the backup usage by device from the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Cursor name.
        [String]$cursor,
        # Include deleted devices.
        [Alias('includeDeletedDevices')]
        [Switch]$includeDeleted,
        # Number of results per page.
        [Int]$pageSize
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = 'v2/queries/backup/usage'
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $BackupUsage = New-NinjaOneGETRequest @RequestParams
        Return $BackupUsage
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}