function New-NinjaOneUnmanagedDevice {
	<#
		.SYNOPSIS
			Creates an unmanaged device.
		.DESCRIPTION
			Creates an unmanaged device via the NinjaOne v2 API.
		.FUNCTIONALITY
			Unmanaged Devices
		.EXAMPLE
			PS> New-NinjaOneUnmanagedDevice -unmanagedDevice @{ hostname='asset-5001' }

			Creates an unmanaged device.
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
	Param(
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
