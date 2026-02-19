function Get-NinjaOneDeviceBackupUsage {
	<#
		.SYNOPSIS
			Gets the backup usage by device from the NinjaOne API.
		.DESCRIPTION
			Retrieves the backup usage by device from the NinjaOne v2 API.
		.FUNCTIONALITY
			Backup Usage Query
		.EXAMPLE
			PS> Get-NinjaOneBackupUsage

			Gets the backup usage by device.
		.EXAMPLE
			PS> Get-NinjaOneBackupUsage -includeDeleted

			Gets the backup usage by device including deleted devices.
		.EXAMPLE
			PS> Get-NinjaOneBackupUsage | Where-Object { ($_.references.backupUsage.cloudTotalSize -ne 0) -or ($_.references.backupUsage.localTotalSize -ne 0) }

			Gets the backup usage by device where the cloud or local total size is not 0.
		.EXAMPLE
			PS> Get-NinjaOneBackupUsage -includeDeleted | Where-Object { ($_.references.backupUsage.cloudTotalSize -ne 0) -and ($_.references.backupUsage.localTotalSize -ne 0) -and ($_.references.backupUsage.revisionsTotalSize -ne 0) }

			Gets the backup usage where the cloud, local and revisions total size is not 0 including deleted devices.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/backupusagequery
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnodbu', 'gnobu', 'Get-NinjaOneBackupUsage')]
	[MetadataAttribute(
		'/v2/queries/backup/usage',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# Cursor name.
		[Parameter(Position = 0)]
		[String]$cursor,
		# Number of results per page.
		[Parameter(Position = 1)]
		[Int]$pageSize,
		# Include deleted devices.
		[Alias('includeDeletedDevices')]
		[Switch]$includeDeleted
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			$Resource = 'v2/queries/backup/usage'
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$BackupUsage = New-NinjaOneGETRequest @RequestParams
			if ($BackupUsage) {
				return $BackupUsage
			} else {
				throw 'No backup usage found.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
