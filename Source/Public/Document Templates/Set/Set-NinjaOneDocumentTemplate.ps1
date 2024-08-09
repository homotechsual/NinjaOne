function Set-NinjaOneDocumentTemplate {
	<#
		.SYNOPSIS
			Sets a document template.
		.DESCRIPTION
			Updates a document template using the NinjaOne v2 API.
		.FUNCTIONALITY
			Document Template
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/documenttemplate
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snodt', 'unodt', 'Update-NinjaOneDocumentTemplate')]
	[MetadataAttribute(
		'/v2/document-templates/{documentTemplateId}',
		'put'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# The document template id to update.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$documentTemplateId,
		# The name of the document template.
		[Parameter(Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[String]$name,
		# The description of the document template.
		[Parameter(Position = 2, ValueFromPipelineByPropertyName)]
		[String]$description,
		# Allow multiple instances of this document template to be used per organisation.
		[Parameter(Position = 3, ValueFromPipelineByPropertyName)]
		[Switch]$allowMultiple,
		# Is this document template mandatory for all organisations.
		[Parameter(Position = 4, ValueFromPipelineByPropertyName)]
		[Switch]$mandatory,
		# The document template fields.
		[Parameter(Mandatory, Position = 5, ValueFromPipelineByPropertyName)]
		[Object[]]$fields,
		# Make this template available to all technicians.
		[Parameter(Position = 6, ValueFromPipelineByPropertyName)]
		[Switch]$availableToAllTechnicians,
		# Set the technician roles that can access this template.
		[Parameter(Position = 7, ValueFromPipelineByPropertyName)]
		[Int[]]$allowedTechnicianRoles,
		# Show the document template that was created.
		[Switch]$show
	)
	begin {
		# Validate the fields parameter.
		foreach ($field in $fields) {
			if ($field.fieldType -in ('DROPDOWN', 'MULTI_SELECT')) {
				if ($null -eq $field.fieldContent) {
					throw 'Field content must be specified for field type {0}.' -f $field.fieldType
				} elseif ($null -eq $field.fieldContent.values) {
					throw 'Field content values must be specified for field type {0}.' -f $field.fieldType
				}
			}
		}
	}
	process {
		try {
			Write-Verbose ('Setting document template {0}.' -f $DocumentTemplate.Name)
			$Resource = ('v2/document-templates/{1}' -f $documentTemplateId)
			$UpdatedDocumentTemplate = @{}
			if ($name) {
				$UpdatedDocumentTemplate.Add('name', $name)
			}
			if ($description) {
				$UpdatedDocumentTemplate.Add('description', $description)
			}
			if ($allowMultiple) {
				$UpdatedDocumentTemplate.Add('allowMultiple', $allowMultiple)
			}
			if ($mandatory) {
				$UpdatedDocumentTemplate.Add('mandatory', $mandatory)
			}
			if ($fields) {
				$UpdatedDocumentTemplate.Add('fields', $fields)
			}
			if ($availableToAllTechnicians) {
				$UpdatedDocumentTemplate.Add('availableToAllTechnicians', $availableToAllTechnicians)
			}
			if ($allowedTechnicianRoles) {
				$UpdatedDocumentTemplate.Add('allowedTechnicianRoles', $allowedTechnicianRoles)
			}
			$RequestParams = @{
				Resource = $Resource
				Body = $UpdatedDocumentTemplate
			}
			if ($PSCmdlet.ShouldProcess(('Document Template {0}' -f $DocumentTemplate.Name), 'Update')) {
				$DocumentTemplateUpdate = New-NinjaOnePOSTRequest @RequestParams
				if ($show) {
					return $DocumentTemplateUpdate
				} elseif ($DocumentTemplateUpdate -eq 204) {
					Write-Information ('Document Template {0} updated successfully.' -f $UpdatedDocumentTemplate.Name)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}