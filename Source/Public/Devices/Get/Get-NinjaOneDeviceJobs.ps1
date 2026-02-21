function Get-NinjaOneDeviceJobs {
	<#
        .SYNOPSIS
            Wrapper command using `Get-NinjaOneJobs` to get jobs for a device.
		.DESCRIPTION
			Gets jobs for a device using the NinjaOne v2 API.
        .FUNCTIONALITY
            Device Jobs
        .EXAMPLE
            Get-NinjaOneDeviceJobs -deviceId 1

            Gets jobs for the device with id 1.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/deviceJobs
    #>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnodj')]
	[MetadataAttribute(
		'/v2/device/{id}/jobs',
		'get'
	)]
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
			$DeviceJobs = Get-NinjaOneJobs -deviceId $deviceId
			if ($DeviceJobs) {
				return $DeviceJobs
			} else {
				New-NinjaOneError -Message ('No jobs found for the device with the id {0}.' -f $deviceId)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}