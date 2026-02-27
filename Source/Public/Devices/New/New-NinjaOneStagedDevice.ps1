function New-NinjaOneStagedDevice {
	<#
		.SYNOPSIS
			Creates a staged device.
		.DESCRIPTION
			Creates a staged device via the NinjaOne v2 API.
		.FUNCTIONALITY
			Devices
		.EXAMPLE
			PS> New-NinjaOneStagedDevice -StagedDevice @{ deviceIdentifier = 'DEVICE-001'; organizationId = 1 }

			Creates a staged device.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				itamAssetStatus = "string"
				itamAssetId = "string"
				itamAssetEndOfLifeDate = 0
				locationId = 0
				itamAssetExpectedLifetime = "string"
				itamAssetPurchaseAmount = 0
				orgId = 0
				name = "string"
				warrantyStartDate = 0
				itamAssetSerialNumber = "string"
				roleId = 0
				warrantyEndDate = 0
				assignedUserUid = "00000000-0000-0000-0000-000000000000"
				itamAssetPurchaseDate = 0
			}
			PS> New-NinjaOneStagedDevice -StagedDevice $body
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
		[Object]$StagedDevice
	)
	process {
		try {
			$Resource = 'v2/staged-device'
			$RequestParams = @{ Resource = $Resource; Body = $StagedDevice }
			if ($PSCmdlet.ShouldProcess('Staged Device', 'Create')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}





