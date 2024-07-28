function New-NinjaOneIntegrityCheckJob {
	<#
		.SYNOPSIS
			Creates a new backup integrity check job using the NinjaOne API.
		.DESCRIPTION
			Create a new backup integrity check job using the NinjaOne v2 API.
		.FUNCTIONALITY
			Integrity Check Job
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
	Param(
		# The deviceId to create the integrity check job for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id', 'deviceId')]
		[Int]$deviceId,
		# The planUid to create the integrity check job for.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[GUID]$planUid,
		# Show the integrity check job that was created.
		[Switch]$show
	)
	process {
		try {
			$Resource = 'v2/backups/integrity-check-jobs'
			$Body = @{
				deviceId = $deviceId
				planUid = $planUid
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
					$OIP = $InformationPreference
					$InformationPreference = 'Continue'
					Write-Information ('Integrity Check Job {0} created.' -f $IntegrityCheckJobCreate.jobUid)
					$InformationPreference = $OIP
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}