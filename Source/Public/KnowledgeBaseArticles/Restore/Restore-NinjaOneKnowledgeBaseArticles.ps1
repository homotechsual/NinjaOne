function Restore-NinjaOneKnowledgeBaseArticles {
	<#
		.SYNOPSIS
			Restores archived knowledge base articles.
		.DESCRIPTION
			Restores archived knowledge base articles via the NinjaOne v2 API.
		.FUNCTIONALITY
			Knowledge Base Articles
		.EXAMPLE
			PS> Restore-NinjaOneKnowledgeBaseArticles -articleIds @(1,2,3)

			Restores the specified articles.
		.OUTPUTS
			Status code (204) on success.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Restore/kb-articles
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('rtnokba')]
	[MetadataAttribute(
		'/v2/knowledgebase/articles/restore',
		'post'
	)]
	Param(
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Int[]]$articleIds
	)
	process {
		try {
			$Resource = 'v2/knowledgebase/articles/restore'
			$RequestParams = @{ Resource = $Resource; Body = $articleIds }
			if ($PSCmdlet.ShouldProcess('Knowledge Base Articles', 'Restore')) {
				$Response = New-NinjaOnePOSTRequest @RequestParams
				return $Response
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

