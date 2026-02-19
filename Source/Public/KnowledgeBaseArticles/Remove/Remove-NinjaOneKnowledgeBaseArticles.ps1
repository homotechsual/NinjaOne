function Remove-NinjaOneKnowledgeBaseArticles {
	<#
		.SYNOPSIS
			Deletes knowledge base articles.
		.DESCRIPTION
			Deletes knowledge base articles via the NinjaOne v2 API.
		.FUNCTIONALITY
			Knowledge Base Articles
		.EXAMPLE
			PS> Remove-NinjaOneKnowledgeBaseArticles -articleIds @(1,2,3) -Confirm:$false

			Deletes the specified articles.
		.OUTPUTS
			Status code (204) on success.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/kb-articles
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('rnokba')]
	[MetadataAttribute(
		'/v2/knowledgebase/articles/delete',
		'post'
	)]
	param(
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Int[]]$articleIds
	)
	process {
		try {
			$Resource = 'v2/knowledgebase/articles/delete'
			$RequestParams = @{ Resource = $Resource; Body = $articleIds }
			if ($PSCmdlet.ShouldProcess('Knowledge Base Articles', 'Delete')) {
				$Response = New-NinjaOnePOSTRequest @RequestParams
				return $Response
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

