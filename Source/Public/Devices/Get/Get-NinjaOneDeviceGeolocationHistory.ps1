function Get-NinjaOneDeviceGeolocationHistory {
	<#
		.SYNOPSIS
			Gets geolocation history for a mobile device.
		.DESCRIPTION
			Retrieves one page of mobile device geolocation history. The API defaults to
			the last seven days and the time window cannot exceed seven days.
			Use the returned cursor to retrieve subsequent pages.
		.FUNCTIONALITY
			Device Geolocation History
		.EXAMPLE
			PS> Get-NinjaOneDeviceGeolocationHistory -deviceId 1 -pageSize 100

			Gets the first page of geolocation history for device 1.
		.EXAMPLE
			PS> Get-NinjaOneDeviceGeolocationHistory -deviceId 1 -after 1791244800 -before 1791849600 -cursor 'next-page'

			Gets a subsequent page within the specified epoch-second time window.
		.OUTPUTS
			A PowerShell object containing geolocation history and pagination information.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicegeolocationhistory
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnodgh')]
	[MetadataAttribute('/v2/device/{id}/geolocation/history', 'get')]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The mobile device id.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$deviceId,
		# Include records on or after this timestamp in epoch seconds.
		[Parameter()]
		[ValidateRange(0, [Double]::MaxValue)]
		[Double]$after,
		# Include records on or before this timestamp in epoch seconds.
		[Parameter()]
		[ValidateRange(0, [Double]::MaxValue)]
		[Double]$before,
		# Limit the number of records per page. The API default is 100.
		[Parameter()]
		[ValidateRange(10, 500)]
		[Int]$pageSize,
		# Cursor returned by the previous page.
		[Parameter()]
		[String]$cursor
	)
	process {
		try {
			if ($PSBoundParameters.ContainsKey('after') -and $PSBoundParameters.ContainsKey('before')) {
				if ($before -lt $after -or ($before - $after) -gt 604800) {
					throw 'The geolocation time window must be ordered and cannot exceed seven days.'
				}
			}
			$CommandName = $MyInvocation.InvocationName
			$Parameters = (Get-Command -Name $CommandName).Parameters
			foreach ($name in @('deviceId', 'after', 'before')) {
				$Parameters.Remove($name) | Out-Null
			}
			$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
			# The shared query builder does not handle the API's fractional epoch seconds.
			foreach ($name in @('after', 'before')) {
				if ($PSBoundParameters.ContainsKey($name)) {
					$QSCollection.Add($name, $PSBoundParameters[$name].ToString('R', [System.Globalization.CultureInfo]::InvariantCulture))
				}
			}
			Write-Verbose ('Getting geolocation history for device {0}.' -f $deviceId)
			$RequestParams = @{
				Resource = ('v2/device/{0}/geolocation/history' -f $deviceId)
				QSCollection = $QSCollection
			}
			return New-NinjaOneGETRequest @RequestParams
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
