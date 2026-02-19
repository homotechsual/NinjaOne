function Remove-NinjaOneRelatedItems {
	<#
		.SYNOPSIS
			Removes the item relationships for the given entity type and entity id.
		.DESCRIPTION
			Removes the item relationships for the given entity type and entity id using the NinjaOne v2 API.
		.FUNCTIONALITY
			Related Items
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/relateditems
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('rnoris')]
	[MetadataAttribute(
		'/v2/related-items/{entityType}/{entityId}',
		'delete'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The entity type to remove related items for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[ValidateSet('ORGANIZATION', 'DOCUMENT', 'LOCATION', 'NODE', 'ATTACHMENT', 'TECHNICIAN', 'CREDENTIAL', 'CHECKLIST', 'END_USER', 'CONTACT', 'KB_DOCUMENT')]
		[String]$entityType,
		# The entity id to remove related items for.
		[Parameter(Mandatory, Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$entityId
	)
	process {
		try {
			$Resource = ('v2/related-items/{0}/{1}' -f $entityType, $entityId)
			$RequestParams = @{
				Resource = $Resource
			}
			if ($PSCmdlet.ShouldProcess(('Related Items for entity {0} with id {1}' -f $entityType, $entityId), 'Delete')) {
				$RelatedItemsDelete = New-NinjaOneDELETERequest @RequestParams
				if ($RelatedItemsDelete -eq 204) {
					Write-Information ('Related items for entity {0} with id {1} deleted successfully.' -f $entityType, $entityId)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
