function New-NinjaOneCustomField {
	<#
		.SYNOPSIS
			Creates a new custom field.
		.DESCRIPTION
			Creates a new custom field (node attribute) via the NinjaOne v2 API.
		.FUNCTIONALITY
			Custom Fields
		.EXAMPLE
			PS> New-NinjaOneCustomField -CustomField @{ name = 'Department'; type = 'TEXT' }

			Creates a new custom field named 'Department' with type 'TEXT'.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				apiPermission = "NONE"
				content = @{
					advancedSettings = @{
						templates = @(
							0
						)
						org = @(
							0
						)
						expandLargeValueOnRender = $false
						ipAddressType = "ALL"
						monetary = @{
							currency = "USD"
						}
						nodeClass = @(
							"WINDOWS_SERVER"
						)
						fileMaxSize = 0
						maxCharacters = 0
						fileExtensions = @(
							"string"
						)
						complexityRules = @{
							mustContainOneInteger = $false
							mustContainOneLowercaseLetter = $false
							mustContainOneUppercaseLetter = $false
							greaterOrEqualThanSixCharacters = $false
						}
						identifier = @{
							automaticGenerationEnabled = $false
							prefix = "string"
							assignTo = "NEW_ASSETS_ONLY"
							nextSequenceNumber = 0
							type = "CUSTOM"
							scope = "NONE"
							suffix = "string"
						}
						numericRange = @{
							max = 0
							min = 0
						}
						dateFilters = @{
							type = "NONE"
							selected = @(
								"string"
							)
						}
					}
					tooltipText = "string"
					required = $false
					footerText = "string"
					values = @(
						@{
							name = "string"
						}
					)
				}
				description = "string"
				type = "DROPDOWN"
				groupId = 0
				scriptPermission = "NONE"
				addToDefaultTab = $false
				technicianPermission = "NONE"
				defaultValue = "string"
				definitionScope = @(
					"NODE"
				)
				label = "string"
				scope = "NODE_GLOBAL"
				fieldName = "string"
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





