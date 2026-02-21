function Set-NinjaOneLocationCustomFields {
	<#
		.SYNOPSIS
			Sets an location's custom fields.
		.DESCRIPTION
			Sets location custom field values using the NinjaOne v2 API.
		.FUNCTIONALITY
			Location Custom Fields
		.EXAMPLE
			PS> $LocationCustomFields = @{
				field1 = 'value1'
				field2 = 'value2'
			}
			PS> Update-NinjaOneLocationCustomFields -organisationId 1 -locationId 2 -locationCustomFields $LocationCustomFields

			Updates the custom fields for the location with id 2 belonging to the organisation with id 1.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/locationcustomfields
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snolcf', 'unolcf', 'Update-NinjaOneLocationCustomFields')]
	[MetadataAttribute(
		'/v2/organization/{id}/location/{locationId}/custom-fields',
		'patch'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The organisation to set the custom fields for.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('id', 'organizationId')]
		[Int]$organisationId,
		# The location to set the custom fields for.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Int]$locationId,
		# The organisation custom field body object.
		[Parameter(Mandatory, Position = 2, ValueFromPipelineByPropertyName)]
		[Alias('customFields', 'body')]
		[Object]$locationCustomFields
	)
	process {
		try {
			Write-Verbose ('Setting location custom fields for location {0}.' -f $locationId)
			$Resource = ('v2/organization/{0}/location/{1}/custom-fields' -f $organisationId, $locationId)
			$RequestParams = @{
				Resource = $Resource
				Body = $locationCustomFields
			}
			if ($PSCmdlet.ShouldProcess(('Location custom fields for {0} in {1}' -f $locationId, $organisationId), 'Update')) {
				$LocationCustomFieldsUpdate = New-NinjaOnePATCHRequest @RequestParams
				if ($LocationCustomFieldsUpdate -eq 204) {
					Write-Information ('Location {0} custom fields updated successfully.' -f $locationId)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
