function New-NinjaOneDocumentTemplate {
	<#
		.SYNOPSIS
			Creates a new document template using the NinjaOne API.
		.DESCRIPTION
			Create a new document template using the NinjaOne v2 API.
		.FUNCTIONALITY
			Document Template
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/documenttemplate
	
	.EXAMPLE
		PS> $newObject = @{ Name = 'Example' }
		PS> New-NinjaOneDocumentTemplate @newObject

		Creates a new resource with the specified properties.

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
