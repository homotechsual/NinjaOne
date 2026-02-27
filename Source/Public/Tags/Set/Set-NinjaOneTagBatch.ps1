function Set-NinjaOneTagBatch {
	<#
		.SYNOPSIS
			Batch update tags for assets.
		.DESCRIPTION
			Updates tags for multiple assets of the specified asset type via the NinjaOne v2 API. Tags will be added and removed as specified for the supplied asset IDs.
		.FUNCTIONALITY
			Asset Tags
		.EXAMPLE
			PS> $tagPayload = @{
				assetIds = @(123, 456)
				tagIdsToAdd = @(1, 2)
				tagIdsToRemove = @(3, 4)
			}
			PS> Set-NinjaOneTagBatch -assetType 'device' -tagUpdate $tagPayload

			Adds tags 1 and 2 to devices 123 and 456, and removes tags 3 and 4 from them.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				assetIds = @(
					0
				)
				tagIdsToAdd = @(
					0
				)
				tagIdsToRemove = @(
					0
				)
			}
			PS> Set-NinjaOneTagBatch -assetType string -tagUpdate $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A PowerShell object containing the batch update result.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/tagbatch
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snotagb')]
	[MetadataAttribute(
		'/v2/tag/{assetType}',
		'post'
	)]
	param(
		# The asset type the tags apply to (e.g. device).
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[String]$assetType,
		# The batch tag update payload per API schema (assetIds, tagIdsToAdd, tagIdsToRemove).
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$tagUpdate
	)
	process {
		try {
			$Resource = ('v2/tag/{0}' -f $assetType)
			$RequestParams = @{ Resource = $Resource; Body = $tagUpdate }
			if ($PSCmdlet.ShouldProcess(('Batch tag update for {0}' -f $assetType), 'Update')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}










