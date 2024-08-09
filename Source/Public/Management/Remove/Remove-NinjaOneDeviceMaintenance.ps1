function Remove-NinjaOneDeviceMaintenance {
	<#
		.SYNOPSIS
			Cancels scheduled maintenance for the given device.
		.DESCRIPTION
			Cancels scheduled maintenance for the given device using the NinjaOne v2 API.
		.FUNCTIONALITY
			Maintenance
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/maintenance
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('rnodm')]
	[MetadataAttribute(
		'/v2/device/{id}/maintenance',
		'delete'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# The device Id to cancel maintenance for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$deviceId
	)
	process {
		try {
			$Resource = ('v2/device/{0}/maintenance' -f $deviceId)
			$RequestParams = @{
				Resource = $Resource
			}
			if ($PSCmdlet.ShouldProcess(('{0} Maintenance' -f $deviceId), 'Delete')) {
				$DeviceMaintenance = New-NinjaOneDELETERequest @RequestParams
				if ($DeviceMaintenance -eq 204) {
					Write-Information ('Scheduled device maintenance for device {0} deleted successfully.' -f $deviceId)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}