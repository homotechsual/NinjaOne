function Set-NinjaOneUnmanagedDevice {
	<#
		.SYNOPSIS
			Updates an unmanaged device.
		.DESCRIPTION
			Updates an unmanaged device via the NinjaOne v2 API.
		.FUNCTIONALITY
			Unmanaged Devices
		.EXAMPLE
			PS> Set-NinjaOneUnmanagedDevice -nodeId 5001 -unmanagedDevice @{ hostname = 'asset-5001' }

			Updates unmanaged device 5001.
		.OUTPUTS
			Status code or updated resource per API.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/unmanageddevice
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snoud')]
	[MetadataAttribute(
		'/v2/itam/unmanaged-device/{nodeId}',
		'put'
	)]
	param(
		# Unmanaged device node Id
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Int]$nodeId,
		# Update payload
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$unmanagedDevice
	)
	process {
		try {
			$Resource = ('v2/itam/unmanaged-device/{0}' -f $nodeId)
			$RequestParams = @{ Resource = $Resource; Body = $unmanagedDevice }
			if ($PSCmdlet.ShouldProcess(('Unmanaged Device {0}' -f $nodeId), 'Update')) {
				$Result = New-NinjaOnePUTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}


