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
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				warrantyEndDate = 0
				orgId = 0
				assetFields = @{
					assetExpectedLifetime = "string"
					serialNumber = "string"
					assetPurchaseAmount = 0
					assetPurchaseDate = 0
					assetId = "string"
					assetStatus = "string"
				}
				warrantyStartDate = 0
				name = "string"
				locationId = 0
				assignedUserUid = "00000000-0000-0000-0000-000000000000"
			}
			PS> Set-NinjaOneUnmanagedDevice -unmanagedDevice $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
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






