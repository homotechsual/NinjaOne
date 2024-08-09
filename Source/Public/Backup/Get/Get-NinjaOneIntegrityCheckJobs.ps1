
function Get-NinjaOneIntegrityCheckJobs {
	<#
		.SYNOPSIS
			Gets backup integrity check jobs from the NinjaOne API.
		.DESCRIPTION
			Retrieves backup integrity check jobs from the NinjaOne v2 API.
		.FUNCTIONALITY
			Integrity Check Jobs
		.EXAMPLE
			PS> Get-NinjaOneIntegrityCheckJobs

			Gets all backup integrity check jobs.
		.EXAMPLE
			PS> Get-NinjaOneIntegrityCheckJobs -status 'RUNNING'

			Gets all backup integrity check jobs with a status of 'RUNNING'.
		.EXAMPLE
			PS> Get-NinjaOneIntegrityCheckJobs -status 'RUNNING', 'COMPLETED'

			Gets all backup integrity check jobs with a status of 'RUNNING' or 'COMPLETED'.
		.EXAMPLE
			PS> Get-NinjaOneIntegrityCheckJobs -statusFilter 'status = RUNNING'

			Gets all backup integrity check jobs with a status of 'RUNNING'.
		.EXAMPLE
			PS> Get-NinjaOneIntegrityCheckJobs -statusFilter 'status in (RUNNING, COMPLETED)'

			Gets all backup integrity check jobs with a status of 'RUNNING' or 'COMPLETED'.
		.EXAMPLE
			PS> Get-NinjaOneIntegrityCheckJobs -planType 'IMAGE'

			Gets all backup integrity check jobs with a plan type of 'IMAGE'.
		.EXAMPLE
			PS> Get-NinjaOneIntegrityCheckJobs -planType 'IMAGE', 'FILE_FOLDER'

			Gets all backup integrity check jobs with a plan type of 'IMAGE' or 'FILE_FOLDER'.
		.EXAMPLE
			PS> Get-NinjaOneIntegrityCheckJobs -planTypeFilter 'planType = IMAGE'

			Gets all backup integrity check jobs with a plan type of 'IMAGE'.
		.EXAMPLE
			PS> Get-NinjaOneIntegrityCheckJobs -planTypeFilter 'planType in (IMAGE, FILE_FOLDER)'

			Gets all backup integrity check jobs with a plan type of 'IMAGE' or 'FILE_FOLDER'.
		.EXAMPLE
			PS> Get-NinjaOneIntegrityCheckJobs -startTimeBetween (Get-Date).AddDays(-1), (Get-Date)

			Gets all backup integrity check jobs with a start time between 24 hours ago and now.
		.EXAMPLE
			PS> Get-NinjaOneIntegrityCheckJobs -startTimeAfter (Get-Date).AddDays(-1)

			Gets all backup integrity check jobs with a start time after 24 hours ago.
		.EXAMPLE
			PS> Get-NinjaOneIntegrityCheckJobs -startTimeFilter 'startTime between(2024-01-01T00:00:00.000Z,2024-01-02T00:00:00.000Z)'

			Gets all backup integrity check jobs with a start time between 2024-01-01T00:00:00.000Z and 2024-01-02T00:00:00.000Z.
		.EXAMPLE
			PS> Get-NinjaOneIntegrityCheckJobs -startTimeFilter 'startTime after 2024-01-01T00:00:00.000Z'

			Gets all backup integrity check jobs with a start time after 2024-01-01T00:00:00.000Z.
		.EXAMPLE
			PS> Get-NinjaOneIntegrityCheckJobs -deviceFilter all

			Gets all backup integrity check jobs for the all devices. Includes active and deleted devices.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/integritycheckjobs
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnoicj')]
	[MetadataAttribute(
		'/v2/backup/integrity-check-jobs',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# Cursor name.
		[Parameter(Position = 0, ValueFromPipelineByPropertyName)]
		[String]$cursor,
		# Deleted device filter.
		[Parameter(Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('ddf')]
		[String]$deletedDeviceFilter,
		# Device filter.
		[Parameter(Position = 2, ValueFromPipelineByPropertyName)]
		[Alias('df')]
		[String]$deviceFilter,
		# Which devices to include (defaults to 'active').
		[Parameter(Position = 3, ValueFromPipelineByPropertyName)]
		[ValidateSet('active', 'deleted', 'all')]
		[String]$include,
		# Number of results per page.
		[Parameter(Position = 4, ValueFromPipelineByPropertyName)]
		[Int]$pageSize,
		# Filter by plan type. See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/ptf
		[Parameter(Position = 5, ValueFromPipelineByPropertyName)]
		[ValidateSet('IMAGE, FILE_FOLDER')]
		[String]$planType,
		# Raw plan type filter. See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/ptf
		[Parameter(Position = 6, ValueFromPipelineByPropertyName)]
		[Alias('ptf')]
		[String]$planTypeFilter,
		# Filter by status. See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/sf
		[Parameter(Position = 6, ValueFromPipelineByPropertyName)]
		[ValidateSet('PROCESSING', 'RUNNING', 'COMPLETED', 'CANCELED', 'FAILED')]
		[String]$status,
		# Raw status filter. See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/sf
		[Parameter(Position = 7, ValueFromPipelineByPropertyName)]
		[Alias('sf')]
		[String]$statusFilter,
		# Start time between filter. See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/stf
		[Parameter(Position = 8, ValueFromPipelineByPropertyName)]
		[ValidateCount(2, 2)]
		[DateTime[]]$startTimeBetween,
		# Start time after filter. See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/stf
		[Parameter(Position = 9, ValueFromPipelineByPropertyName)]
		[DateTime]$startTimeAfter,
		# Raw start time filter. See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/stf
		[Parameter(Position = 10, ValueFromPipelineByPropertyName)]
		[Alias('stf')]
		[String]$startTimeFilter
	)
	begin {
		# Preprocess the $status parameter to the format for the sf filter.
		if ($status.Count -eq 1) {
			$statusFilter = ('status = {0}' -f $status)
		} elseif ($status.Count -gt 1) {
			$statusFilter = ('status in ({0})' -f ($status -join ','))
		}
		# Preprocess the $planType parameter to the format for the ptf filter.
		if ($planType.Count -eq 1) {
			$planTypeFilter = ('planType = {0}' -f $planType)
		} elseif ($planType.Count -gt 1) {
			$planTypeFilter = ('planType in ({0})' -f ($planType -join ','))
		}
		# Preprocess the $startTimeBetween parameter to the format for the stf filter.
		if ($startTimeBetween) {
			$startTimeFilter = ('startTime between({0},{1})' -f $startTimeBetween[0].ToUniversalTime().ToString('o'), $startTimeBetween[1].ToUniversalTime().ToString('o'))
		}
		# Preprocess the $startTimeAfter parameter to the format for the stf filter.
		if ($startTimeAfter) {
			$startTimeFilter = ('startTime after {0}' -f $startTimeAfter.ToUniversalTime().ToString('o'))
		}
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		if ($status) {
			# Workaround to prevent the query string processor from adding a 'status=' parameter by removing it from the set parameters.
			$Parameters.Remove('status') | Out-Null
		}
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			$Resource = '/v2/backup/integrity-check-jobs'
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$IntegrityCheckJobsResults = New-NinjaOneGETRequest @RequestParams
			return $IntegrityCheckJobsResults
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}