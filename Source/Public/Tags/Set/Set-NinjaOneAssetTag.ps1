function Set-NinjaOneAssetTag {
	<#
		.SYNOPSIS
			Updates tag assignments for an asset.
		.DESCRIPTION
			Updates tags for a specific asset type and asset Id via the NinjaOne v2 API.
		.FUNCTIONALITY
			Asset Tag Assignment
		.EXAMPLE
			PS> Set-NinjaOneAssetTag -assetType 'NODE' -assetId 123 -tagAssignment @{ tagIds = @(1, 2, 3) }

			Updates tag assignments for node 123 with tags 1, 2, and 3.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				tagIds = @(
					0
				)
			}
			PS> Set-NinjaOneAssetTag -assetType string -assetId 1 -tagAssignment $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
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










