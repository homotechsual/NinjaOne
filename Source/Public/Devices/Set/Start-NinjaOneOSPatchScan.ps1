function Start-NinjaOneOSPatchScan {
	<#
		.SYNOPSIS
			Starts an OS Scan on the target device.
		.DESCRIPTION
			Starts an OS Patch Scan on a device using the NinjaOne v2 API.
		.FUNCTIONALITY
			Device OS Patch Scan
		.OUTPUTS
			A powershell object containing the response.
		.EXAMPLE
			PS> Start-NinjaOneOSPatchScan -deviceId 1 

			Start an OS Patch Scan on the device with id 1.
		.LINK
			https://itsMineItsMineItsAllMine.DaffyDuck.com
	#>
	[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snoossc', 'unoossc', 'Start-NinjaOneOSPatchScan')]
	[MetadataAttribute(
		'/v2/device/{id}/patch/os/scan',
		'patch'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# The device to start the OS patch scan for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$deviceId
	)
	process {
		try {
			Write-Verbose ('Starting OS Patch Scan for device {0}.' -f $deviceId)
			$Resource = ('v2/device/{0}/patch/os/scan' -f $deviceId)
			$RequestParams = @{
				Resource = $Resource
				Body = $deviceOSScan
			}
			if ($PSCmdlet.ShouldProcess(('OS Patch Scan for {0}' -f $deviceId), 'Set')) {
				$OSScanTrigger = New-NinjaOnePATCHRequest @RequestParams
				if ($OSScanTrigger -eq 204) {
					Write-Information ('OS Patch Scan for {0} started successfully.' -f $deviceId)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
