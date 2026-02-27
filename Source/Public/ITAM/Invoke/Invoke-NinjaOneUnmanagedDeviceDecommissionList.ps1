function Invoke-NinjaOneUnmanagedDeviceDecommissionList {
	<#
		.SYNOPSIS
			Decommissions multiple unmanaged devices.
		.DESCRIPTION
			Decommissions multiple unmanaged devices via the NinjaOne v2 API.
		.FUNCTIONALITY
			Unmanaged Devices
		.EXAMPLE
			PS> Invoke-NinjaOneUnmanagedDeviceDecommissionList -DecommissionRequest @{ nodeIds = @(1, 2, 3) }

			Decommissions multiple unmanaged devices in a single request.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				nodeIds = @(
					0
				)
			}
			PS> Invoke-NinjaOneUnmanagedDeviceDecommissionList -DecommissionRequest $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			The API response indicating success or failure.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/unmanageddevicedecommission-list
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
	[OutputType([Object])]
	[Alias('inouddl')]
	[MetadataAttribute(
		'/v2/itam/unmanaged-device/decommissionList',
		'post'
	)]
	param(
		# Decommission request payload per API schema
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$DecommissionRequest
	)
	process {
		try {
			$Resource = 'v2/itam/unmanaged-device/decommissionList'
			$RequestParams = @{ Resource = $Resource; Body = $DecommissionRequest }
			if ($PSCmdlet.ShouldProcess('Unmanaged Devices', 'Decommission List')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}





