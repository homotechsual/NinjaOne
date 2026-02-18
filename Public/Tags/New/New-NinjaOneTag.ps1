function New-NinjaOneTag {
	<#
		.SYNOPSIS
			Creates a new asset tag.
		.DESCRIPTION
			Creates a new asset tag for the specified asset type via the NinjaOne v2 API.
		.FUNCTIONALITY
			Asset Tags
		.EXAMPLE
			PS> New-NinjaOneTag -assetType 'NODE' -tag @{ name = 'Critical'; color = '#FF0000' }

			Creates a new tag named 'Critical' for asset type NODE.
		.OUTPUTS
			A PowerShell object containing the created tag.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/tag
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnotag')]
	[MetadataAttribute(
		'/v2/tag/{assetType}',
		'post'
	)]
	Param(
		# The asset type the tag applies to (e.g. NODE, ORGANIZATION, LOCATION).
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[String]$assetType,
		# The tag object payload per API schema.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$tag
	)
	process {
		try {
			$Resource = ('v2/tag/{0}' -f $assetType)
			$RequestParams = @{ Resource = $Resource; Body = $tag }
			if ($PSCmdlet.ShouldProcess(('Tag for {0}' -f $assetType), 'Create')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

