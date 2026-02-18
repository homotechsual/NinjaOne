function Start-NinjaOneSoftwarePatchApply {
	<#
		.SYNOPSIS
			Starts a Software Patch Apply on the target device.
		.DESCRIPTION
			Submits a job to start a software patch apply on a device via the NinjaOne v2 API.
		.FUNCTIONALITY
			Device Software Patch Apply
		.EXAMPLE
			PS> Start-NinjaOneSoftwarePatchApply -deviceId 1

			Start a Software Patch Apply on the device with id 1.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/softwarepatchapply
	#>
	[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snoswpa')]
	[MetadataAttribute(
		'/v2/device/{id}/patch/software/apply',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# The device to start the software patch apply for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$deviceId
	)
	process {
		try {
			Write-Verbose ('Starting Software Patch Apply for device {0}.' -f $deviceId)
			$Resource = ('v2/device/{0}/patch/software/apply' -f $deviceId)
			$RequestParams = @{ Resource = $Resource }
			if ($PSCmdlet.ShouldProcess(('Software Patch Apply for {0}' -f $deviceId), 'Start')) {
				$Response = New-NinjaOnePOSTRequest @RequestParams
				return $Response
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

