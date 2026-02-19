function Set-NinjaOneTag {
	<#
		.SYNOPSIS
			Updates an asset tag.
		.DESCRIPTION
			Updates an existing tag via the NinjaOne v2 API.
		.FUNCTIONALITY
			Asset Tags
		.EXAMPLE
			PS> Set-NinjaOneTag -tagId 12 -tag @{ name = 'Priority-1' }

			Updates the tag with Id 12.
		.OUTPUTS
			Status code or updated resource per API.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/tag
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snotag')]
	[MetadataAttribute(
		'/v2/tag/{tagId}',
		'put'
	)]
	param(
		# The tag Id to update.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$tagId,
		# The tag update payload.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$tag
	)
	process {
		try {
			$Resource = ('v2/tag/{0}' -f $tagId)
			$RequestParams = @{ Resource = $Resource; Body = $tag }
			if ($PSCmdlet.ShouldProcess(('Tag {0}' -f $tagId), 'Update')) {
				$Result = New-NinjaOnePUTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

