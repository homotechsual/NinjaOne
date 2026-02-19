function Remove-NinjaOneUnmanagedDevice {
	<#
		.SYNOPSIS
			Deletes an unmanaged device.
		.DESCRIPTION
			Deletes an unmanaged device via the NinjaOne v2 API.
		.FUNCTIONALITY
			Unmanaged Devices
		.EXAMPLE
			PS> Remove-NinjaOneUnmanagedDevice -nodeId 5001 -Confirm:$false

			Deletes unmanaged device 5001.
		.OUTPUTS
			Status code (204) on success.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/unmanageddevice
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('rnoud')]
	[MetadataAttribute(
		'/v2/itam/unmanaged-device/{nodeId}',
		'delete'
	)]
	param(
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Int]$nodeId
	)
	process {
		try {
			$Resource = ('v2/itam/unmanaged-device/{0}' -f $nodeId)
			$RequestParams = @{ Resource = $Resource }
			if ($PSCmdlet.ShouldProcess(('Unmanaged Device {0}' -f $nodeId), 'Delete')) {
				$Response = New-NinjaOneDELETERequest @RequestParams
				if ($Response -eq 204) { Write-Information ('Unmanaged device {0} deleted.' -f $nodeId) }
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
