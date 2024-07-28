function Reset-NinjaOneDevicePolicyOverrides {
	<#
		.SYNOPSIS
			Resets (removes) device policy overrides using the NinjaOne API.
		.DESCRIPTION
			Resets (removes) all configured device policy overrides using the NinjaOne v2 API.
		.FUNCTIONALITY
			Device Policy Overrides
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Reset/devicepolicyoverrides
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('rnodpo')]
	[MetadataAttribute(
		'/v2/device/{id}/policy/overrides',
		'delete'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# The device Id to reset policy overrides for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$deviceId
	)
	process {
		try {
			$Device = Get-NinjaOneDevice -deviceId $deviceId
			if ($Device) {
				Write-Verbose ('Resetting device policy overrides for device {0}.' -f $Device.SystemName)
				$Resource = ('v2/device/{0}/policy/overrides' -f $deviceId)
			} else {
				throw ('Device with id {0} not found.' -f $deviceId)
			}
			$RequestParams = @{
				Resource = $Resource
			}
			if ($PSCmdlet.ShouldProcess(('Device Policy Overrides for {0}' -f $Device.SystemName), 'Reset')) {
				$PolicyOverrides = New-NinjaOneDELETERequest @RequestParams
				if ($PolicyOverrides -eq 204) {
					Write-Information ('Device policy overrides for {0} reset successfully.' -f $Device.SystemName)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}