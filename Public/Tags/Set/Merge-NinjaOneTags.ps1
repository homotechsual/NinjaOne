function Merge-NinjaOneTags {
	<#
		.SYNOPSIS
			Merges asset tags.
		.DESCRIPTION
			Merges tags via the NinjaOne v2 API using the tag merge endpoint.
		.FUNCTIONALITY
			Asset Tags
		.EXAMPLE
			PS> Merge-NinjaOneTags -mergeRequest @{ sourceTagIds = @(5,6); targetTagId = 1 }

			Merges tags 5 and 6 into tag 1.
		.OUTPUTS
			Status code or merged tag per API.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/tag-merge
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('mnotags')]
	[MetadataAttribute(
		'/v2/tag/merge',
		'post'
	)]
	Param(
		# Merge request payload as per API schema (source/target tag ids)
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$mergeRequest
	)
	process {
		try {
			$Resource = 'v2/tag/merge'
			$RequestParams = @{ Resource = $Resource; Body = $mergeRequest }
			if ($PSCmdlet.ShouldProcess('Tags', 'Merge')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

