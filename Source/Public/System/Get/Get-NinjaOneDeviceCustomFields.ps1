
function Get-NinjaOneDeviceCustomFields {
	<#
		.SYNOPSIS
			Gets device custom fields from the NinjaOne API.
		.DESCRIPTION
			Retrieves device custom fields from the NinjaOne v2 API.
		.FUNCTIONALITY
			Device Custom Fields
		.EXAMPLE
			PS> Get-NinjaOneDeviceCustomFields

			Gets all device custom fields.
		.EXAMPLE
			PS> Get-NinjaOneDeviceCustomFields | Group-Object { $_.scope }

			Gets all device custom fields grouped by the scope property.
		.EXAMPLE
			PS> Get-NinjaOneDeviceCustomFields -deviceId 1

			Gets the device custom fields and values for the device with id 1
		.EXAMPLE
			PS> Get-NinjaOneDeviceCustomFields -deviceId 1 -withInheritance

			Gets the device custom fields and values for the device with id 1 and inherits values from parent location and/or organisation, if no value is set for the device you will get the value from the parent location and if no value is set for the parent location you will get the value from the parent organisation.
		.OUTPUTS
			A powershell object containing the response
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/contacts
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnodcf')]
	[MetadataAttribute(
		'/v2/device/{id}/custom-fields',
		'get',
		'/v2/device-custom-fields',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# Device id to get custom field values for a specific device.
		[Parameter(Mandatory, ParameterSetName = 'Single', Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$deviceId,
		# The scopes to get custom field definitions for.
		[Parameter(ParameterSetName = 'Multi', Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[ValidateSet('all', 'node', 'location', 'organisation')]
		[String[]]$scope = 'all'
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		# Workaround to prevent the query string processor from adding an 'deviceid=' parameter by removing it from the set parameters.
		$Parameters.Remove('deviceId') | Out-Null
		# If $scope has more than one value preprocess the value to a comma separated string.
		if ($scope.Count -gt 1) {
			$scope = $scope -join ','
		}
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			if ($deviceId) {
				Write-Verbose ('Getting custom fields for device {0}.' -f $deviceId)
				$Resource = ('v2/device/{0}/custom-fields' -f $deviceId)
			} else {
				Write-Verbose 'Retrieving all device custom fields.'
				$Resource = 'v2/device-custom-fields'
			}
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$DeviceCustomFieldResults = New-NinjaOneGETRequest @RequestParams
			return $DeviceCustomFieldResults
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
