function Set-NinjaOneCustomField {
	<#
		.SYNOPSIS
			Updates a custom field by field name.
		.DESCRIPTION
			Updates an existing custom field identified by its unique field name via the NinjaOne v2 API.
		.FUNCTIONALITY
			Custom Field
		.EXAMPLE
			PS> Set-NinjaOneCustomField -FieldName 'department' -CustomField @{ description = 'Department of the user' }

			Updates the custom field named 'department' with new description.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				label = "string"
				fieldName = "string"
				description = "string"
				type = "DROPDOWN"
				technicianPermission = "NONE"
				scriptPermission = "NONE"
				apiPermission = "NONE"
				defaultValue = "string"
				content = @{
					values = @(
						@{
							id = "00000000-0000-0000-0000-000000000000"
							name = "string"
							active = $false
							system = $false
						}
					)
					required = $false
					footerText = "string"
					tooltipText = "string"
					advancedSettings = @{
						fileMaxSize = 0
						fileExtensions = @(
							"string"
						)
						dateFilters = @{
							type = "NONE"
							selected = @(
								"string"
							)
						}
						maxCharacters = 0
						complexityRules = @{
							mustContainOneInteger = $false
							mustContainOneLowercaseLetter = $false
							mustContainOneUppercaseLetter = $false
							greaterOrEqualThanSixCharacters = $false
						}
						numericRange = @{
							min = 0
							max = 0
						}
						org = @(
							0
						)
						nodeClass = @(
							"WINDOWS_SERVER"
						)
						ipAddressType = "ALL"
						expandLargeValueOnRender = $false
						identifier = @{
							automaticGenerationEnabled = $false
							scope = "NONE"
							assignTo = "NEW_ASSETS_ONLY"
							type = "CUSTOM"
							nextSequenceNumber = 0
							prefix = "string"
							suffix = "string"
						}
						monetary = @{
							currency = "USD"
						}
						templates = @(
							0
						)
					}
				}
				active = $false
				scope = "NODE_GLOBAL"
				definitionScope = @(
					"NODE"
				)
				groupId = 0
			}
			PS> Set-NinjaOneCustomField -FieldName string -CustomField $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
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
		[Alias('name')]
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









