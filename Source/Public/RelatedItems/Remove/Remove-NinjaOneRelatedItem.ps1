function Remove-NinjaOneRelatedItem {
	<#
		.SYNOPSIS
			Removes the given item relationship.
		.DESCRIPTION
			Removes the given item relationship link using the NinjaOne v2 API.
		.FUNCTIONALITY
			Related Item
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/relateditem
	
	.EXAMPLE
		PS> Remove-NinjaOneRelatedItem -Identity 123

		Removes the specified resource.

	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('rnori')]
	[MetadataAttribute(
		'/v2/related-items/{relatedItemId}',
		'delete'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The related item id to remove.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$relatedItemId
	)
	process {
		try {
			$Resource = ('v2/related-items/{0}' -f $relatedItemId)
			$RequestParams = @{
				Resource = $Resource
			}
			if ($PSCmdlet.ShouldProcess(('Related Item {0}' -f $relatedItemId), 'Delete')) {
				$RelatedItemDelete = New-NinjaOneDELETERequest @RequestParams
				if ($RelatedItemDelete -eq 204) {
					Write-Information ('Relation {0} deleted successfully.' -f $relatedItemId)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
