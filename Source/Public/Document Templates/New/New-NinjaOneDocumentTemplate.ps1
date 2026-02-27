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
				name = "string"
				description = "string"
				allowMultiple = $false
				mandatory = $false
				fields = @(
					@{
						fieldLabel = "string"
						fieldName = "string"
						fieldDescription = "string"
						fieldType = "DROPDOWN"
						fieldTechnicianPermission = "NONE"
						fieldScriptPermission = "NONE"
						fieldApiPermission = "NONE"
						fieldDefaultValue = "string"
						fieldContent = @{
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
						uiElementName = "string"
						uiElementType = "TITLE"
						uiElementValue = "string"
					}
				)
				availableToAllTechnicians = $false
				allowedTechnicianRoles = @(
					0
				)
			}
			PS> New-NinjaOneDocumentTemplate -name $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/documenttemplate
	#>
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









