
function Get-NinjaOneDevicePolicyOverrides {
	<#
		.SYNOPSIS
			Gets device policy overrides from the NinjaOne API.
		.DESCRIPTION
			Retrieves device policy override sections from the NinjaOne v2 API.
		.FUNCTIONALITY
			Device Policy Overrides
		.EXAMPLE
			PS> Get-NinjaOneDevicePolicyOverrides -deviceId 1

			Gets the policy override sections for the device with id 1.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicepolicyoverrides
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnodpo')]
	[MetadataAttribute(
		'/v2/device/{id}/policy/overrides',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# Device id to get the policy overrides for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$deviceId,
		# Expand the overrides property.
		[Switch]$expandOverrides
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
			Write-Verbose ('Getting policy overrides for device {0}.' -f $Device.SystemName)
			$Resource = ('v2/device/{0}/policy/overrides' -f $deviceId)
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$DeviceLastLoggedOnUserResults = New-NinjaOneGETRequest @RequestParams
			if ($expandOverrides) {
				return $DeviceLastLoggedOnUserResults | Select-Object -ExpandProperty Overrides
			} else {
				return $DeviceLastLoggedOnUserResults
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}