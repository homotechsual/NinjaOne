function New-NinjaOneIntegrityCheckJob {
	<#
		.SYNOPSIS
			Creates a new backup integrity check job using the NinjaOne API.
		.DESCRIPTION
			Create a new backup integrity check job using the NinjaOne v2 API.
		.FUNCTIONALITY
			Integrity Check Job
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				planUid = "00000000-0000-0000-0000-000000000000"
				deviceId = 0
			}
			PS> New-NinjaOneIntegrityCheckJob -integrityCheckJob $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/integritycheckjob
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnol')]
	[MetadataAttribute(
		'/v2/backup/integrity-check-jobs',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The deviceId to create the integrity check job for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'Individual')]
		[Alias('id')]
		[Int]$deviceId,
		# The planUid to create the integrity check job for.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName, ParameterSetName = 'Individual')]
		[GUID]$planUid,
		# The integrity check job body object (alternative to individual parameters).
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, ParameterSetName = 'Body')]
		[Alias('body')]
		[Object]$integrityCheckJob,
		# Show the integrity check job that was created.
		[Switch]$show
	)
	process {
		try {
			$Resource = 'v2/backups/integrity-check-jobs'
			if ($PSCmdlet.ParameterSetName -eq 'Body') {
				$Body = $integrityCheckJob
			} else {
				$Body = @{
					deviceId = $deviceId
					planUid = $planUid
				}
			}
			$RequestParams = @{
				Resource = $Resource
				Body = $Body
			}
			if ($PSCmdlet.ShouldProcess(('Integrity Check Job for device {0} plan {1}' -f $deviceId, $planUid), 'Create')) {
				$IntegrityCheckJobCreate = New-NinjaOnePOSTRequest @RequestParams
				if ($show) {
					return $IntegrityCheckJobCreate
				} else {
					Write-Information ('Integrity Check Job {0} created.' -f $IntegrityCheckJobCreate.jobUid)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}









