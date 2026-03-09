function New-NinjaOneCustomField {
	<#
		.SYNOPSIS
			Creates a new custom field.
		.DESCRIPTION
			Creates a new custom field (node attribute) via the NinjaOne v2 API.
		.FUNCTIONALITY
			Custom Field
		.EXAMPLE
			PS> New-NinjaOneCustomField -CustomField @{ name = 'Department'; type = 'TEXT' }

			Creates a new custom field named 'Department' with type 'TEXT'.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				addToDefaultTab = $false
				scriptPermission = "NONE"
				type = "DROPDOWN"
				groupId = 0
				content = @{
					values = @(
						@{
							name = "string"
						}
					)
					footerText = "string"
					required = $false
					tooltipText = "string"
					advancedSettings = @{
						complexityRules = @{
							greaterOrEqualThanSixCharacters = $false
							mustContainOneUppercaseLetter = $false
							mustContainOneInteger = $false
							mustContainOneLowercaseLetter = $false
						}
						monetary = @{
							currency = "USD"
						}
						ipAddressType = "ALL"
						fileMaxSize = 0
						fileExtensions = @(
							"string"
						)
						templates = @(
							0
						)
						org = @(
							0
						)
						dateFilters = @{
							selected = @(
								"string"
							)
							type = "NONE"
						}
						identifier = @{
							nextSequenceNumber = 0
							automaticGenerationEnabled = $false
							prefix = "string"
							suffix = "string"
							scope = "NONE"
							type = "CUSTOM"
							assignTo = "NEW_ASSETS_ONLY"
						}
						numericRange = @{
							min = 0
							max = 0
						}
						maxCharacters = 0
						nodeClass = @(
							"WINDOWS_SERVER"
						)
						expandLargeValueOnRender = $false
					}
				}
				description = "string"
				scope = "NODE_GLOBAL"
				definitionScope = @(
					"NODE"
				)
				defaultValue = "string"
				technicianPermission = "NONE"
				fieldName = "string"
				apiPermission = "NONE"
				label = "string"
			}
			PS> New-NinjaOneCustomField -CustomField $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A PowerShell object containing the created custom field.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/customfield
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnoodcf')]
	[MetadataAttribute(
		'/v2/custom-fields',
		'post'
	)]
	param(
		# Custom field configuration per API schema
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$CustomField
	)
	process {
		try {
			$Resource = 'v2/custom-fields'
			$RequestParams = @{ Resource = $Resource; Body = $CustomField }
			if ($PSCmdlet.ShouldProcess('Custom Fields', 'Create')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}










