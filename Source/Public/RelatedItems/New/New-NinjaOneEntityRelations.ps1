function New-NinjaOneEntityRelations {
	<#
		.SYNOPSIS
			Creates multiple new entity relations using the NinjaOne API.
		.DESCRIPTION
			Create multiple new entity relations using the NinjaOne v2 API.
		.FUNCTIONALITY
			Entity Relations
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/entityrelations
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnoers')]
	[MetadataAttribute(
		'/v2/related-items/entity/{entityType}/{entityId}/relations',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The entity type to create the entity relation for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[ValidateSet('ORGANIZATION', 'DOCUMENT', 'LOCATION', 'NODE', 'CHECKLIST', 'KB_DOCUMENT')]
		[String]$entityType,
		# The entity id to create the entity relation for.
		[Parameter(Mandatory, Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$entityId,
		# The entity relations to create.
		[Parameter(Mandatory, Position = 2, ValueFromPipelineByPropertyName)]
		[Object[]]$entityRelations,
		# Show the entity relation that was created.
		[Switch]$show
	)
	process {
		try {
			$Resource = ('v2/related-items/entity/{0}/{1}/relations' -f $entityType, $entityId)
			$Body = $entityRelations
			$RequestParams = @{
				Resource = $Resource
				Body = $Body
			}
			if ($PSCmdlet.ShouldProcess(('Entity relations for {0} with id {1}' -f $entityType, $entityId), 'Create')) {
				$EntityRelationCreate = New-NinjaOnePOSTRequest @RequestParams
				if ($show) {
					return $EntityRelationCreate
				} else {
					Write-Information ('Entity relations for {0} with id {1} created.' -f $entityType, $entityId)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
