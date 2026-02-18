function Remove-NinjaOneTags {
	<#
		.SYNOPSIS
			Deletes asset tags.
		.DESCRIPTION
			Deletes one or more tags via the NinjaOne v2 API using a POST delete endpoint.
		.FUNCTIONALITY
			Asset Tags
		.EXAMPLE
			PS> Remove-NinjaOneTags -deleteRequest @{ tagIds = @(1,2,3) }

			Deletes tags with Ids 1,2,3.
		.OUTPUTS
			Status code (usually 200/204) per API.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/tags
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('rnotags')]
	[MetadataAttribute(
		'/v2/tag/delete',
		'post'
	)]
	Param(
		# Delete request payload as per API schema (e.g. tagIds array)
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$deleteRequest
	)
	process {
		try {
			$Resource = 'v2/tag/delete'
			$RequestParams = @{ Resource = $Resource; Body = $deleteRequest }
			if ($PSCmdlet.ShouldProcess('Tags', 'Delete')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

