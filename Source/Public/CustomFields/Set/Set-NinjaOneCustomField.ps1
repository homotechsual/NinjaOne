function Set-NinjaOneCustomField {
	<#
		.SYNOPSIS
			Updates a custom field by field name.
		.DESCRIPTION
			Updates an existing custom field identified by its unique field name via the NinjaOne v2 API.
		.FUNCTIONALITY
			Custom Fields
		.EXAMPLE
			PS> Set-NinjaOneCustomField -FieldName 'department' -CustomField @{ description = 'Department of the user' }

			Updates the custom field named 'department' with new description.
		.OUTPUTS
			A PowerShell object containing the updated custom field.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/customfield
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snoodcf')]
	[MetadataAttribute(
		'/v2/custom-fields/field-name/{fieldName}',
		'put'
	)]
	param(
		# The field name of the custom field to update
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('name', 'fieldname')]
		[String]$FieldName,
		# Custom field update payload per API schema
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$CustomField
	)
	process {
		try {
			$Resource = ('v2/custom-fields/field-name/{0}' -f $FieldName)
			$RequestParams = @{ Resource = $Resource; Body = $CustomField }
			if ($PSCmdlet.ShouldProcess('Custom Field', ('Update {0}' -f $FieldName))) {
				$Result = New-NinjaOnePUTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
