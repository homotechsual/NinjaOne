function New-NinjaOneUnmanagedDevice {
	<#
		.SYNOPSIS
			Creates an unmanaged device.
		.DESCRIPTION
			Creates an unmanaged device via the NinjaOne v2 API.
		.FUNCTIONALITY
			Unmanaged Device
		.EXAMPLE
			PS> New-NinjaOneUnmanagedDevice -unmanagedDevice @{ hostname='asset-5001' }

			Creates an unmanaged device.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				warrantyStartDate = 0
				orgId = 0
				assignedUserUid = "00000000-0000-0000-0000-000000000000"
				assetFields = @{
					assetExpectedLifetime = "string"
					assetPurchaseAmount = 0
					assetPurchaseDate = 0
					serialNumber = "string"
					assetId = "string"
					assetStatus = "string"
				}
				locationId = 0
				roleId = 0
				name = "string"
				warrantyEndDate = 0
			}
			PS> New-NinjaOneUnmanagedDevice -unmanagedDevice $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A PowerShell object containing the created unmanaged device Id.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/unmanageddevice
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnoUD')]
	[MetadataAttribute(
		'/v2/itam/unmanaged-device',
		'post'
	)]
	param(
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$unmanagedDevice
	)
	process {
		try {
			$RequestParams = @{ Resource = 'v2/itam/unmanaged-device'; Body = $unmanagedDevice }
			if ($PSCmdlet.ShouldProcess('Unmanaged Device', 'Create')) { return (New-NinjaOnePOSTRequest @RequestParams) }
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}










