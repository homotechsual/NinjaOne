function Invoke-NinjaOneDeviceDecommission {
	<#
		.SYNOPSIS
			Decommissions a device.
		.DESCRIPTION
			Decommissions a device via the NinjaOne v2 API.
		.FUNCTIONALITY
			Devices
		.EXAMPLE
			PS> Invoke-NinjaOneDeviceDecommission -DeviceId 1

			Decommissions the device with ID 1.
		.OUTPUTS
			The API response indicating success or failure.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/devicedecommission
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
	[OutputType([Object])]
	[Alias('inood')]
	[MetadataAttribute(
		'/v2/device/{id}/decommission',
		'post'
	)]
	param(
		# The ID of the device to decommission
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('id', 'deviceid', 'nodeid')]
		[Int]$DeviceId
	)
	process {
		try {
			$Resource = ('v2/device/{0}/decommission' -f $DeviceId)
			if ($PSCmdlet.ShouldProcess('Device', ('Decommission {0}' -f $DeviceId))) {
				$Result = New-NinjaOnePOSTRequest -Resource $Resource
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
