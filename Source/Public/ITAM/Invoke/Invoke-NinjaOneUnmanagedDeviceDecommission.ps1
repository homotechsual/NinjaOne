function Invoke-NinjaOneUnmanagedDeviceDecommission {
	<#
		.SYNOPSIS
			Decommissions an unmanaged device.
		.DESCRIPTION
			Decommissions an unmanaged device via the NinjaOne v2 API.
		.FUNCTIONALITY
			Unmanaged Devices
		.EXAMPLE
			PS> Invoke-NinjaOneUnmanagedDeviceDecommission -NodeId 1

			Decommissions the unmanaged device with ID 1.
		.OUTPUTS
			The API response indicating success or failure.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/unmanageddevicedecommission
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
	[OutputType([Object])]
	[Alias('inoudd')]
	[MetadataAttribute(
		'/v2/itam/unmanaged-device/{nodeId}/decommission',
		'post'
	)]
	param(
		# The ID of the unmanaged device to decommission
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$NodeId
	)
	process {
		try {
			$Resource = ('v2/itam/unmanaged-device/{0}/decommission' -f $NodeId)
			if ($PSCmdlet.ShouldProcess('Unmanaged Device', ('Decommission {0}' -f $NodeId))) {
				$Result = New-NinjaOnePOSTRequest -Resource $Resource
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
