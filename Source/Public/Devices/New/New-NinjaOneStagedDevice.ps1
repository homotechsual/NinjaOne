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
