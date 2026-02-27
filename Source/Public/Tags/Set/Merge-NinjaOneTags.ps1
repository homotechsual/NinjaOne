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
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				tagIds = @(
					0
				)
				mergeMethod = "MERGE_INTO_EXISTING_TAG"
				mergeIntoTagId = 0
				name = "string"
				description = "string"
			}
			PS> Merge-NinjaOneTags -mergeRequest $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
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
	param(
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










