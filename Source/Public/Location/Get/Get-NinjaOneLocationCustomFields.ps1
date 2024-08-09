function Get-NinjaOneLocationCustomFields {
	<#
		.SYNOPSIS
			Gets location custom fields from the NinjaOne API.
		.DESCRIPTION
			Retrieves location custom fields from the NinjaOne v2 API.
		.FUNCTIONALITY
			Location Custom Fields
		.EXAMPLE
			Get-NinjaOneLocationCustomFields organisationId 1 -locationId 2

			Gets custom field details for the location with id 2 belonging to the organisation with id 1.
		.EXAMPLE
			Get-NinjaOneLocationCustomFields organisationId 1 -locationId 2 -withInheritance

			Gets custom field details for the location with id 2 belonging to the organisation with id 1 and inherits values from parent organisation, if no value is set for the location you will get the value from the parent organisation.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/locationcustomfields
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnolcf')]
	[MetadataAttribute(
		'/v2/organization/{id}/location/{locationId}/custom-fields',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# Filter by organisation id.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('id', 'organizationId')]
		[Int]$organisationId,
		# Filter by location id.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Int]$locationId,
		# Inherit custom field values from parent organisation.
		[Parameter(Position = 2, ValueFromPipelineByPropertyName)]
		[Boolean]$withInheritance
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		# Workaround to prevent the query string processor from adding an 'organisationid=' parameter by removing it from the set parameters.
		$Parameters.Remove('organisationId') | Out-Null
		# Workaround to prevent the query string processor from adding an 'locationid=' parameter by removing it from the set parameters.
		$Parameters.Remove('locationId') | Out-Null
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			Write-Verbose 'Getting organisation custom fields from NinjaOne API.'
			Write-Verbose ('Getting custom fields for organisation {0} - location {1}.' -f $organisationId, $locationId)
			$Resource = ('v2/organization/{0}/location/{1}/custom-fields' -f $organisationId, $locationId)
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$CustomFieldResults = New-NinjaOneGETRequest @RequestParams
			if ($CustomFieldResults) {
				return $CustomFieldResults
			} else {
				throw ('No custom fields found for organisation {0} - location {1}.' -f $organisationId, $locationId)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}