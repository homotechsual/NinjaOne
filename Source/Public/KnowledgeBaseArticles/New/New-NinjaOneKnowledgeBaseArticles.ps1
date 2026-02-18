function New-NinjaOneKnowledgeBaseArticles {
	<#
		.SYNOPSIS
			Creates knowledge base articles.
		.DESCRIPTION
			Creates one or more knowledge base articles via the NinjaOne v2 API.
		.FUNCTIONALITY
			Knowledge Base Articles
		.EXAMPLE
			PS> New-NinjaOneKnowledgeBaseArticles -articles @{ organizationId = 1; folderId = 10; articles = @(@{ name='A'; content='...'} ) }

			Creates knowledge base articles in the specified folder.
		.OUTPUTS
			A PowerShell object containing the created articles or job result.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/knowledgebase-articles
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnokba')]
	[MetadataAttribute(
		'/v2/knowledgebase/articles',
		'post'
	)]
	Param(
		# Articles payload per API schema
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$articles
	)
	process {
		try {
			$Resource = 'v2/knowledgebase/articles'
			$RequestParams = @{ Resource = $Resource; Body = $articles }
			if ($PSCmdlet.ShouldProcess('Knowledge Base Articles', 'Create')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

