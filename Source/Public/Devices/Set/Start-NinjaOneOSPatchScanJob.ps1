function Start-NinjaOneOSPatchScanJob {
	<#
		.SYNOPSIS
			Starts an OS Patch Scan job on the target device.
		.DESCRIPTION
			Submits a job (POST) to start an OS patch scan on a device via the NinjaOne v2 API. Complements the PATCH variant.
		.FUNCTIONALITY
			Device OS Patch Scan
		.EXAMPLE
			PS> Start-NinjaOneOSPatchScanJob -deviceId 1

			Starts an OS Patch Scan job on device 1.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/ospatchscan
	#>
	[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snoossp')]
	[MetadataAttribute(
		'/v2/device/{id}/patch/os/scan',
		'post'
	)]
	param(
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$deviceId
	)
	process {
		try {
			$Resource = ('v2/device/{0}/patch/os/scan' -f $deviceId)
			$RequestParams = @{ Resource = $Resource }
			if ($PSCmdlet.ShouldProcess(('OS Patch Scan for {0}' -f $deviceId), 'Start')) {
				return (New-NinjaOnePOSTRequest @RequestParams)
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

