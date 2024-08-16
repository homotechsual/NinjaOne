function New-NinjaOneAttachmentRelation {
	<#
		.SYNOPSIS
			Creates a new attachment relation using the NinjaOne API.
		.DESCRIPTION
			Create a new attachment relation using the NinjaOne v2 API.
		.FUNCTIONALITY
			Attachment Relation
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/attachmentrelation
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnoar')]
	[MetadataAttribute(
		'/v2/related-items/entity/{entityType}/{entityId}/attachment',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# The entity type to create the attachment relation for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[ValidateSet('ORGANIZATION', 'DOCUMENT', 'LOCATION', 'NODE', 'CHECKLIST', 'KB_DOCUMENT')]
		[String]$entityType,
		# The entity id to create the attachment relation for.
		[Parameter(Mandatory, Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$entityId,
		# The attachment relation data.
		[Parameter(Position = 2, ValueFromPipelineByPropertyName)]
		[Object]$attachmentRelation,
		# Show the attachment relation that was created.
		[Switch]$show
	)
	process {
		try {
			$Resource = ('v2/related-items/entity/{0}/{1}/attachment' -f $entityType, $entityId)
			$Body = $attachmentRelation
			$RequestParams = @{
				Resource = $Resource
				Body = $Body
			}
			if ($PSCmdlet.ShouldProcess(('Attachment relation for {0} with id {1}' -f $entityType, $entityId), 'Create')) {
				$AttachmentRelationCreate = New-NinjaOnePOSTRequest @RequestParams
				if ($show) {
					return $AttachmentRelationCreate
				} else {
					Write-Information ('Attachment relation created for {0} with id {1}' -f $entityType, $entityId)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}