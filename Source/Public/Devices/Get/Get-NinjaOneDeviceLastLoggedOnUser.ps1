
function Get-NinjaOneDeviceLastLoggedOnUser {
	<#
		.SYNOPSIS
			Gets device last logged on user from the NinjaOne API.
		.DESCRIPTION
			Retrieves device last logged on user from the NinjaOne v2 API.
		.FUNCTIONALITY
			Device Last Logged On User
		.EXAMPLE
			PS> Get-NinjaOneDeviceLastLoggedOnUser -deviceId 1

			Gets the last logged on user for the device with id 1.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicelastloggedonuser
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnodllou')]
	[MetadataAttribute(
		'/v2/device/{id}/last-logged-on-user',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# Device id to get the last logged on user for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$deviceId
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		# Workaround to prevent the query string processor from adding an 'deviceid=' parameter by removing it from the set parameters.
		$Parameters.Remove('deviceId') | Out-Null
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			Write-Verbose ('Getting last logged on user for device {0}.' -f $Device.SystemName)
			$Resource = ('v2/device/{0}/last-logged-on-user' -f $deviceId)
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$DeviceLastLoggedOnUserResults = New-NinjaOneGETRequest @RequestParams
			return $DeviceLastLoggedOnUserResults
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}