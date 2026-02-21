function Set-NinjaOneAssetTag {
	<#
		.SYNOPSIS
			Updates tag assignments for an asset.
		.DESCRIPTION
			Updates tags for a specific asset type and asset Id via the NinjaOne v2 API.
		.FUNCTIONALITY
			Asset Tags
		.EXAMPLE
			PS> Set-NinjaOneAssetTag -assetType 'NODE' -assetId 123 -tagAssignment @{ tagIds = @(1,2) }

			Assigns tags 1 and 2 to node 123.
		.OUTPUTS
			Status code or updated assignment per API.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/assettag
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snoatag')]
	[MetadataAttribute(
		'/v2/tag/{assetType}/{assetId}',
		'put'
	)]
	param(
		# Asset type (e.g. NODE, ORGANIZATION, LOCATION)
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[String]$assetType,
		# Asset Id
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Int]$assetId,
		# Tag assignment payload
		[Parameter(Mandatory, Position = 2, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$tagAssignment
	)
	process {
		try {
			$Resource = ('v2/tag/{0}/{1}' -f $assetType, $assetId)
			$RequestParams = @{ Resource = $Resource; Body = $tagAssignment }
			if ($PSCmdlet.ShouldProcess(('{0} {1}' -f $assetType, $assetId), 'Update Tags')) {
				$Result = New-NinjaOnePUTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

