function Set-NinjaOneDevice {
	<#
		.SYNOPSIS
			Sets device information, like friendly name, user data etc.
		.DESCRIPTION
			Sets device information using the NinjaOne v2 API.
		.FUNCTIONALITY
			Device
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/device
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snod', 'unod', 'Update-NinjaOneDevice')]
	[MetadataAttribute(
		'/v2/device/{id}',
		'patch'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# The device to set the information for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$deviceId,
		# The device information body object.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Object]$deviceInformation
	)
	process {
		try {
			Write-Verbose ('Setting device information for device {0}.' -f $deviceId)
			$Resource = ('v2/device/{0}' -f $deviceId)
			$RequestParams = @{
				Resource = $Resource
				Body = $deviceInformation
			}
			if ($PSCmdlet.ShouldProcess(('Device {0} information' -f $deviceId), 'Update')) {
				$DeviceUpdate = New-NinjaOnePATCHRequest @RequestParams
				if ($DeviceUpdate -eq 204) {
					Write-Information ('Device {0} information updated successfully.' -f $deviceId)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}