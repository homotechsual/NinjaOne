function Get-NinjaOneDeviceHealth {
	<#
		.SYNOPSIS
			Gets the device health from the NinjaOne API.
		.DESCRIPTION
			Retrieves the device health from the NinjaOne v2 API.
		.FUNCTIONALITY
			Device Health Query
		.EXAMPLE
			PS> Get-NinjaOneDeviceHealth

			Gets the device health.
		.EXAMPLE
			PS> Get-NinjaOneDeviceHealth -deviceFilter 'org = 1'

			Gets the device health for the organisation with id 1.
		.EXAMPLE
			PS> Get-NinjaOneDeviceHealth -health 'UNHEALTHY'

			Gets the device health for devices with the health status 'UNHEALTHY'.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicehealthquery
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnodh')]
	[MetadataAttribute(
		'/v2/queries/device-health',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# Filter devices.
		[Parameter(Position = 0)]
		[Alias('df')]
		[String]$deviceFilter,
		# Filter by health status.
		[Parameter(Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[ValidateSet('UNHEALTHY', 'HEALTHY', 'UNKNOWN', 'NEEDS_ATTENTION')]
		[String]$health,
		# Cursor name.
		[Parameter(Position = 2)]
		[String]$cursor,
		# Number of results per page.
		[Parameter(Position = 3)]
		[Int]$pageSize
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			$Resource = 'v2/queries/device-health'
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$DeviceHealth = New-NinjaOneGETRequest @RequestParams
			if ($DeviceHealth) {
				return $DeviceHealth
			} else {
				throw 'No device health found.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
