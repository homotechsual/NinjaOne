function Restart-NinjaOneDevice {
	<#
		.SYNOPSIS
			Reboots a device using the NinjaOne API.
		.DESCRIPTION
			Triggers a device reboot using the NinjaOne v2 API.
		.FUNCTIONALITY
			Device
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Restart/device
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('rnod')]
	[MetadataAttribute(
		'/v2/device/{id}/reboot/{mode}',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# The device Id to reset status for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$deviceId,
		# The reboot mode.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[ValidateSet('NORMAL', 'FORCED')]
		[String]$mode,
		# The reboot reason.
		[Parameter(Position = 3, ValueFromPipelineByPropertyName)]
		[String]$reason
	)
	process {
		try {
			Write-Verbose ('Rebooting device {0}.' -f $deviceId)
			$Resource = ('v2/device/{0}/reboot/{1}' -f $deviceId, $mode)
			$RequestParams = @{
				Resource = $Resource
			}
			if ($reason) {
				$reasonObject = @{
					reason = $reason
				}
				$RequestParams.Add('body', $reasonObject)
			}
			if ($PSCmdlet.ShouldProcess(('Device' -f $deviceId), 'Reboot')) {
				$Alert = New-NinjaOnePOSTRequest @RequestParams
				if ($Alert -eq 204) {
					Write-Information ('Device {0} rebooted command sent successfully.' -f $deviceId)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}