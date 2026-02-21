function Start-NinjaOneSoftwarePatchScan {
	<#
		.SYNOPSIS
			Starts a Software Patch Scan on the target device.
		.DESCRIPTION
			Submits a job to start a software patch scan on a device via the NinjaOne v2 API.
		.FUNCTIONALITY
			Device Software Patch Scan
		.EXAMPLE
			PS> Start-NinjaOneSoftwarePatchScan -deviceId 1

			Start a Software Patch Scan on the device with id 1.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/softwarepatchscan
	#>
	[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snoswps')]
	[MetadataAttribute(
		'/v2/device/{id}/patch/software/scan',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The device to start the software patch scan for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$deviceId
	)
	process {
		try {
			Write-Verbose ('Starting Software Patch Scan for device {0}.' -f $deviceId)
			$Resource = ('v2/device/{0}/patch/software/scan' -f $deviceId)
			$RequestParams = @{ Resource = $Resource }
			if ($PSCmdlet.ShouldProcess(('Software Patch Scan for {0}' -f $deviceId), 'Start')) {
				$Response = New-NinjaOnePOSTRequest @RequestParams
				return $Response
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

