function Get-NinjaOneBackupUsage {
    <#
        .SYNOPSIS
            Gets the backup usage by device from the NinjaOne API.
        .DESCRIPTION
            Retrieves the backup usage by device from the NinjaOne v2 API.
        .EXAMPLE
            PS> Get-NinjaOneBackupUsage

            Gets the backup usage by device.
        .EXAMPLE
            PS> Get-NinjaOneBackupUsage -includeDeleted

            Gets the backup usage by device including deleted devices.
        .EXAMPLE
            PS> Get-NinjaOneBackupUsage | Where-Object { ($_.references.backupUsage.cloudTotalSize -ne 0) -or ($_.references.backupUsage.localTotalSize -ne 0) }

            Gets the backup usage by device where the cloud or local total size is not 0.
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