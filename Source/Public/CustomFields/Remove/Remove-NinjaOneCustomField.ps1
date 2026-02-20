function Remove-NinjaOneCustomField {
	<#
		.SYNOPSIS
			Deletes a custom field by field name.
		.DESCRIPTION
			Deletes an existing custom field identified by its unique field name via the NinjaOne v2 API.
		.FUNCTIONALITY
			Custom Fields
		.EXAMPLE
			PS> Remove-NinjaOneCustomField -FieldName 'department'

			Deletes the custom field named 'department'.
		.OUTPUTS
			The API response indicating success or failure.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/customfield
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
	[OutputType([Object])]
	[Alias('rnoodcf')]
	[MetadataAttribute(
		'/v2/custom-fields/field-name/{fieldName}',
		'delete'
	)]
	param(
		# The field name of the custom field to delete
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('name', 'fieldname')]
		[String]$FieldName
	)
	process {
		try {
			$Resource = ('v2/custom-fields/field-name/{0}' -f $FieldName)
			if ($PSCmdlet.ShouldProcess('Custom Field', ('Delete {0}' -f $FieldName))) {
				$Result = New-NinjaOneDELETERequest -Resource $Resource
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
