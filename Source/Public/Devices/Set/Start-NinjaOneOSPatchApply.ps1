function Start-NinjaOneOSPatchApply {
	<#
		.SYNOPSIS
			Starts an OS Patch Apply on the target device.
		.DESCRIPTION
			Submits a job to start an OS patch apply on a device via the NinjaOne v2 API.
		.FUNCTIONALITY
			Device OS Patch Apply
		.EXAMPLE
			PS> Start-NinjaOneOSPatchApply -deviceId 1

			Start an OS Patch Apply on the device with id 1.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/ospatchapply
	#>
	[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snoospa')]
	[MetadataAttribute(
		'/v2/device/{id}/patch/os/apply',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The device to start the OS patch apply for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$deviceId
	)
	process {
		try {
			Write-Verbose ('Starting OS Patch Apply for device {0}.' -f $deviceId)
			$Resource = ('v2/device/{0}/patch/os/apply' -f $deviceId)
			$RequestParams = @{ Resource = $Resource }
			if ($PSCmdlet.ShouldProcess(('OS Patch Apply for {0}' -f $deviceId), 'Start')) {
				$Response = New-NinjaOnePOSTRequest @RequestParams
				return $Response
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

