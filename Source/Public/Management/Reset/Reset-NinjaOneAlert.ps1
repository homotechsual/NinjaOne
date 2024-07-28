function Reset-NinjaOneAlert {
	<#
		.SYNOPSIS
			Resets alerts using the NinjaOne API.
		.DESCRIPTION
			Resets the status of alerts using the NinjaOne v2 API.
		.FUNCTIONALITY
			Alert
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Reset/alert
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('rnoa')]
	[MetadataAttribute(
		'/v2/alert/{uid}/reset',
		'post',
		'/v2/alert/{uid}',
		'delete'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# The alert Id to reset status for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[String]$uid,
		# The reset activity data.
		[Parameter(Position = 1, ValueFromPipelineByPropertyName)]
		[Object]$activityData
	)
	process {
		try {
			if ($activityData) {
				$Resource = ('v2/alert/{0}/reset' -f $uid)
				$RequestParams = @{
					Resource = $Resource
					Body = $activityData
				}
				if ($PSCmdlet.ShouldProcess(('Alert {0}' -f $uid), 'Reset')) {
					$Alert = New-NinjaOnePOSTRequest @RequestParams
					if ($Alert -eq 204) {
						$OIP = $InformationPreference
						$InformationPreference = 'Continue'
						Write-Information 'Alert reset successfully.'
						$InformationPreference = $OIP
					}
				}
			} else {
				$Resource = ('v2/alert/{0}' -f $uid)
				$RequestParams = @{
					Resource = $Resource
				}
				if ($PSCmdlet.ShouldProcess(('Alert {0}' -f $uid), 'Reset')) {
					$Alert = New-NinjaOneDELETERequest @RequestParams
					if ($Alert -eq 204) {
						Write-Information 'Alert reset successfully.'
					}
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}