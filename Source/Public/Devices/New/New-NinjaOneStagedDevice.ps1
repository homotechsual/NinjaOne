function New-NinjaOneStagedDevice {
	<#
		.SYNOPSIS
			Creates a staged device.
		.DESCRIPTION
			Creates a staged device via the NinjaOne v2 API.
		.FUNCTIONALITY
			Devices
		.EXAMPLE
			PS> New-NinjaOneStagedDevice -stagedDevice @{ deviceIdentifier = 'DEVICE-001'; organizationId = 1 }

			Creates a staged device.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				warrantyEndDate = 0
				itamAssetExpectedLifetime = "string"
				itamAssetStatus = "string"
				orgId = 0
				roleId = 0
				locationId = 0
				itamAssetEndOfLifeDate = 0
				itamAssetSerialNumber = "string"
				itamAssetId = "string"
				warrantyStartDate = 0
				itamAssetPurchaseDate = 0
				assignedUserUid = "00000000-0000-0000-0000-000000000000"
				itamAssetPurchaseAmount = 0
				name = "string"
			}
			PS> New-NinjaOneStagedDevice -stagedDevice $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A PowerShell object containing the created staged device information.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/stageddevice
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnoosd')]
	[MetadataAttribute(
		'/v2/staged-device',
		'post'
	)]
	param(
		# Staged device configuration per API schema
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$stagedDevice
	)
	process {
		try {
			$Resource = 'v2/staged-device'
			$RequestParams = @{ Resource = $Resource; Body = $stagedDevice }
			if ($PSCmdlet.ShouldProcess('Staged Device', 'Create')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}










