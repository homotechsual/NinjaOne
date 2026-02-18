function Invoke-NinjaOneKnowledgeBaseArticlesArchive {
	<#
		.SYNOPSIS
			Archives knowledge base articles.
		.DESCRIPTION
			Archives knowledge base articles via the NinjaOne v2 API.
		.FUNCTIONALITY
			Knowledge Base Articles
		.EXAMPLE
			PS> Invoke-NinjaOneKnowledgeBaseArticlesArchive -articleIds @(1,2,3)

			Archives the specified articles.
		.OUTPUTS
			Status code (204) on success.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/kb-articles-archive
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('inokbaa')]
	[MetadataAttribute(
		'/v2/knowledgebase/articles/archive',
		'post'
	)]
	Param(
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Int[]]$articleIds
	)
	process {
		try {
			$Resource = 'v2/knowledgebase/articles/archive'
			$RequestParams = @{ Resource = $Resource; Body = $articleIds }
			if ($PSCmdlet.ShouldProcess('Knowledge Base Articles', 'Archive')) {
				$Response = New-NinjaOnePOSTRequest @RequestParams
				return $Response
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

