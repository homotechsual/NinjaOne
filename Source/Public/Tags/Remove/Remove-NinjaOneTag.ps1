function Remove-NinjaOneTag {
	<#
		.SYNOPSIS
			Deletes a tag.
		.DESCRIPTION
			Deletes a tag via the NinjaOne v2 API.
		.FUNCTIONALITY
			Asset Tags
		.EXAMPLE
			PS> Remove-NinjaOneTag -tagId 12 -Confirm:$false

			Deletes the tag with Id 12.
		.OUTPUTS
			Status code (204) on success.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/tag
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('rnotag')]
	[MetadataAttribute(
		'/v2/tag/{tagId}',
		'delete'
	)]
	param(
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Int]$tagId
	)
	process {
		try {
			$Resource = ('v2/tag/{0}' -f $tagId)
			$RequestParams = @{ Resource = $Resource }
			if ($PSCmdlet.ShouldProcess(('Tag {0}' -f $tagId), 'Delete')) {
				$Response = New-NinjaOneDELETERequest @RequestParams
				if ($Response -eq 204) { Write-Information ('Tag {0} deleted successfully.' -f $tagId) }
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
