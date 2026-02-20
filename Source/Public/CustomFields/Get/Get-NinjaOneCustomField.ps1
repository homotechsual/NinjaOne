function Get-NinjaOneCustomField {
	<#
		.SYNOPSIS
			Gets a custom field by field name.
		.DESCRIPTION
			Retrieves a specific custom field by its unique field name from the NinjaOne v2 API.
		.FUNCTIONALITY
			Custom Fields
		.EXAMPLE
			PS> Get-NinjaOneCustomField -FieldName 'department'

			Gets the custom field with the name 'department'.
		.OUTPUTS
			A PowerShell object containing the custom field.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/customfield
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnoodcf')]
	[MetadataAttribute(
		'/v2/custom-fields/field-name/{fieldName}',
		'get'
	)]
	param(
		# The field name of the custom field
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('name', 'fieldname')]
		[String]$FieldName
	)
	process {
		try {
			$Resource = ('v2/custom-fields/field-name/{0}' -f $FieldName)
			$RequestParams = @{
				Resource = $Resource
			}
			$CustomFieldResults = New-NinjaOneGETRequest @RequestParams
			if ($CustomFieldResults) {
				return $CustomFieldResults
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
