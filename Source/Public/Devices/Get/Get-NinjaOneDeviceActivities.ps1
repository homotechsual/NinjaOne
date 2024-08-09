function Get-NinjaOneDeviceActivities {
	<#
        .SYNOPSIS
            Wrapper command using `Get-NinjaOneActivities` to get activities for a device.
		.DESCRIPTION
			Gets activities for a device using the NinjaOne v2 API.
        .FUNCTIONALITY
            Device Activities
        .EXAMPLE
            Get-NinjaOneDeviceActivities -deviceId 1

            Gets activities for the device with id 1.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/deviceactivities
    #>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnodac')]
	[MetadataAttribute()]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# Filter by device id.
		[Parameter(Mandatory, ParameterSetName = 'Single Device', Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$deviceId,
		# Return built in job names in the given language.
		[Parameter(ParameterSetName = 'Single Device', Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('lang')]
		[String]$languageTag,
		# Return job times/dates in the given timezone.
		[Parameter(ParameterSetName = 'Single Device', Position = 2, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('tz')]
		[String]$timezone
	)
	begin {	}
	process {
		try {
			$DeviceActivities = Get-NinjaOneActivities -deviceId $deviceId
			if ($DeviceActivities) {
				return $DeviceActivities
			} else {
				New-NinjaOneError -Message ('No activities found for the device with the id {0}.' -f $deviceId)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}