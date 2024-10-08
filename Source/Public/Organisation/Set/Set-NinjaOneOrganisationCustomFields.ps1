function Set-NinjaOneOrganisationCustomFields {
	<#
		.SYNOPSIS
			Updates an organisation's custom fields.
		.DESCRIPTION
			Updates organisation custom field values using the NinjaOne v2 API.
		.FUNCTIONALITY
			Organisation Custom Fields
		.EXAMPLE
			PS> $OrganisationCustomFields = @{
				field1 = 'value1'
				field2 = 'value2'
			}
			PS> Update-NinjaOneOrganisationCustomFields -organisationId 1 -organisationCustomFields $OrganisationCustomFields

			Updates the custom fields for the organisation with id 1.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/organisationcustomfields
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snocf', 'Set-NinjaOneOrganizationCustomFields', 'unocf', 'Update-NinjaOneOrganisationCustomFields', 'Update-NinjaOneOrganizationCustomFields')]
	[MetadataAttribute(
		'/v2/organization/{id}/custom-fields',
		'patch'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# The organisation to set the custom fields for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id', 'organizationId')]
		[Int]$organisationId,
		# The organisation custom field body object.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('customFields', 'body', 'organizationCustomFields')]
		[Object]$organisationCustomFields
	)
	process {
		try {
			Write-Verbose ('Setting organisation custom fields for organisation {0}.' -f $organisationId)
			$Resource = ('v2/organization/{0}/custom-fields' -f $organisationId)
			$RequestParams = @{
				Resource = $Resource
				Body = $organisationCustomFields
			}
			if ($PSCmdlet.ShouldProcess(('Organisation {0} custom fields' -f $organisationId), 'Update')) {
				$OrganisationCustomFieldsUpdate = New-NinjaOnePATCHRequest @RequestParams
				if ($OrganisationCustomFieldsUpdate -eq 204) {
					Write-Information ('Organisation {0} custom fields updated successfully.' -f $organisationId)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}