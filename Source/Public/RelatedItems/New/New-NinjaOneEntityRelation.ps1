function New-NinjaOneEntityRelation {
	<#
		.SYNOPSIS
			Creates a new entity relation using the NinjaOne API.
		.DESCRIPTION
			Create a new entity relation using the NinjaOne v2 API.
		.FUNCTIONALITY
			Entity Relation
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/entityrelation
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnoer')]
	[MetadataAttribute(
		'/v2/related-items/entity/{entityType}/{entityId}/relation',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# The entity type to create the entity relation for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[ValidateSet('ORGANIZATION', 'DOCUMENT', 'LOCATION', 'NODE', 'CHECKLIST', 'KB_DOCUMENT')]
		[String]$entityType,
		# The entity id to create the entity relation for.
		[Parameter(Mandatory, Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$entityId,
		# The entity type to relate to.
		[Parameter(Mandatory, Position = 2, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[ValidateSet('ORGANIZATION', 'DOCUMENT', 'LOCATION', 'NODE', 'ATTACHMENT', 'TECHNICIAN', 'CREDENTIAL', 'CHECKLIST', 'END_USER', 'CONTACT', 'KB_DOCUMENT')]
		[Alias('relEntityType', 'relatedType')]
		[String]$relatedEntityType,
		# The entity id to relate to.
		[Parameter(Mandatory, Position = 3, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('relEntityId', 'relatedId')]
		[Int]$relatedEntityId,
		# Show the entity relation that was created.
		[Switch]$show
	)
	process {
		try {
			$Resource = ('v2/related-items/entity/{0}/{1}/relation' -f $entityType, $entityId)
			$Body = @{
				relEntityType = $relatedEntityType
				relEntityId = $relatedEntityId
			}
			$RequestParams = @{
				Resource = $Resource
				Body = $Body
			}
			if ($PSCmdlet.ShouldProcess(('Entity relation for {0} with id {1}' -f $entityType, $entityId), 'Create')) {
				$EntityRelationCreate = New-NinjaOnePOSTRequest @RequestParams
				if ($show) {
					return $EntityRelationCreate
				} else {
					Write-Information ('Entity relation between {0} with id {1} and {2} with id {3} created.' -f $entityType, $entityId, $relatedEntityType, $relatedEntityId)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}