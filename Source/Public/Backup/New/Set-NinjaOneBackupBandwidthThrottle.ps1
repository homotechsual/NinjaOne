function Set-NinjaOneBackupBandwidthThrottle {
	<#
		.SYNOPSIS
			Sets the bandwidth throttle for a device.
		.DESCRIPTION
			Sets the bandwidth throttle for a device via the NinjaOne v2 API.
		.FUNCTIONALITY
			Backup
		.EXAMPLE
			PS> Set-NinjaOneBackupBandwidthThrottle -ThrottleSetting @{ deviceId = 1; bandwidthLimit = 5242880 }

			Sets the bandwidth throttle for a device.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				bandwidthThrottle = @{
					workHoursKbps = 0
					workHoursUserUnit = "string"
					nonWorkHoursKbps = 0
					nonWorkHoursUserUnit = "string"
					workSchedule = @{
						endHour = 0
						weekDays = @(
							"string"
						)
						endMinute = 0
						startHour = 0
						startMinute = 0
					}
					enabled = $false
				}
				deviceId = 0
			}
			PS> Set-NinjaOneBackupBandwidthThrottle -ThrottleSetting $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			The API response indicating success or failure.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/backup-bandwidth-throttle
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snoobt')]
	[MetadataAttribute(
		'/v2/backup/bandwidth-throttle',
		'post'
	)]
	param(
		# Bandwidth throttle setting payload per API schema
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$ThrottleSetting
	)
	process {
		try {
			$Resource = 'v2/backup/bandwidth-throttle'
			$RequestParams = @{ Resource = $Resource; Body = $ThrottleSetting }
			if ($PSCmdlet.ShouldProcess('Backup Bandwidth Throttle', 'Set')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}










