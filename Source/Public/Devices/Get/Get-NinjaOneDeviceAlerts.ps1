function Get-NinjaOneDeviceAlerts {
	<#
        .SYNOPSIS
            Wrapper command using `Get-NinjaOneAlerts` to get alerts for a device.
        .FUNCTIONALITY
            Device Alerts
        .EXAMPLE
            Get-NinjaOneDeviceAlerts -deviceId 1

            Gets alerts for the device with id 1.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicealerts
    #>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnodal')]
	[MetadataAttribute()]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# Filter by device id.
		[Parameter(Mandatory, ParameterSetName = 'Single Device', Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$deviceId,
		# Return built in condition names in the given language.
		[Parameter(ParameterSetName = 'Single Device', Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('lang')]
		[String]$languageTag,
		# Return alert times/dates in the given timezone.
		[Parameter(ParameterSetName = 'Single Device', Position = 2, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('tz')]
		[String]$timezone
	)
	begin {	}
	process {
		try {
			$DeviceAlerts = Get-NinjaOneAlerts -deviceId $deviceId
			if ($DeviceAlerts) {
				return $DeviceAlerts
			} else {
				New-NinjaOneError -Message ('No Alerts found for the device with the id { 0 }.' -f $deviceId)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}