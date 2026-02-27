function Set-NinjaOneUnmanagedDevice {
	<#
		.SYNOPSIS
			Updates an unmanaged device.
		.DESCRIPTION
			Updates an unmanaged device via the NinjaOne v2 API.
		.FUNCTIONALITY
			Unmanaged Device
		.EXAMPLE
			PS> Set-NinjaOneUnmanagedDevice -nodeId 5001 -unmanagedDevice @{ hostname = 'asset-5001' }

			Updates unmanaged device 5001.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				name = "string"
				orgId = 0
				locationId = 0
				assignedUserUid = "00000000-0000-0000-0000-000000000000"
				warrantyStartDate = 0
				warrantyEndDate = 0
				assetFields = @{
					serialNumber = "string"
					assetId = "string"
					assetStatus = "string"
					assetPurchaseDate = 0
					assetPurchaseAmount = 0
					assetExpectedLifetime = "string"
				}
			}
			PS> Set-NinjaOneUnmanagedDevice -nodeId 1 -unmanagedDevice $body
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










