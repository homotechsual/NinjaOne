function New-NinjaOneDocumentTemplate {
	<#
		.SYNOPSIS
			Creates a new document template using the NinjaOne API.
		.DESCRIPTION
			Create a new document template using the NinjaOne v2 API.
		.FUNCTIONALITY
			Document Template
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				fields = @(
					@{
						fieldDefaultValue = "string"
						uiElementName = "string"
						fieldApiPermission = "NONE"
						fieldScriptPermission = "NONE"
						uiElementValue = "string"
						fieldName = "string"
						fieldLabel = "string"
						fieldContent = @{
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
						fieldType = "DROPDOWN"
						fieldDescription = "string"
						uiElementType = "TITLE"
						fieldTechnicianPermission = "NONE"
					}
				)
				allowMultiple = $false
				allowedTechnicianRoles = @(
					0
				)
				mandatory = $false
				name = "string"
				availableToAllTechnicians = $false
				description = "string"
			}
			PS> New-NinjaOneDocumentTemplate -name $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/documenttemplate`n`t#>
	[CmdletBinding( SupportsShouldProcess, ConfirmImpact = 'Medium' )]
	[OutputType([Object])]
	[Alias('nnodt')]
	[MetadataAttribute(
		'/v2/document-templates',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The name of the document template.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[String]$name,
		# The description of the document template.
		[Parameter(Position = 1, ValueFromPipelineByPropertyName)]
		[String]$description,
		# Allow multiple instances of this document template to be used per organisation.
		[Parameter(Position = 2, ValueFromPipelineByPropertyName)]
		[Switch]$allowMultiple,
		# Is this document template mandatory for all organisations.
		[Parameter(Position = 3, ValueFromPipelineByPropertyName)]
		[Switch]$mandatory,
		# The document template fields.
		[Parameter(Mandatory, Position = 4, ValueFromPipelineByPropertyName)]
		[PSTypeName('DocumentTemplateField')][Object[]]$fields,
		# Make this template available to all technicians.
		[Parameter(Position = 6, ValueFromPipelineByPropertyName)]
		[Switch]$availableToAllTechnicians,
		# Set the technician roles that can access this template.
		[Parameter(Position = 7, ValueFromPipelineByPropertyName)]
		[Int[]]$allowedTechnicianRoles,
		# Show the document template that was created.
		[Switch]$show
	)
	process {
		try {
			$DocumentTemplate = @{
				name = $name
				description = $description
				allowMultiple = $allowMultiple
				mandatory = $mandatory
				fields = $fields
				availableToAllTechnicians = $availableToAllTechnicians
				allowedTechnicianRoles = $allowedTechnicianRoles
			}
			$Resource = 'v2/document-templates'
			$RequestParams = @{
				Resource = $Resource
				Body = $DocumentTemplate
			}
			if ($PSCmdlet.ShouldProcess(('Document Template {0}' -f $DocumentTemplate.name), 'Create')) {
				$DocumentTemplateCreate = New-NinjaOnePOSTRequest @RequestParams
				if ($show) {
					return $DocumentTemplateCreate
				} else {
					Write-Information ('Document Template {0} created.' -f $DocumentTemplateCreate.name)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}





