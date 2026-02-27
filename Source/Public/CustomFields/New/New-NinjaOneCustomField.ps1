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
							name = "string"
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
				scope = "NODE_GLOBAL"
				definitionScope = @(
					"NODE"
				)
				groupId = 0
				addToDefaultTab = $false
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









