function Set-NinjaOneKnowledgeBaseArticles {
	<#
		.SYNOPSIS
			Updates knowledge base articles.
		.DESCRIPTION
			Updates one of more knowledge base articles via the NinjaOne v2 API.
		.FUNCTIONALITY
			Knowledge Base Articles
		.EXAMPLE
			PS> Set-NinjaOneKnowledgeBaseArticles -articles @{ articles = @(@{ id=1; name='New' }) }

			Updates the specified KB articles.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @(
				@{
					id = 0
					name = "string"
					content = @{
						html = "string"
						text = "string"
					}
				}
			)
			PS> Set-NinjaOneKnowledgeBaseArticles -articles $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/knowledgebase-articles
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[OutputType([Object])]
	[Alias('snonkba')]
	[MetadataAttribute(
		'/v2/knowledgebase/articles',
		'patch'
	)]
	param(
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$articles
	)
	process {
		try {
			if($PSCmdlet.ShouldProcess('Knowledge Base Articles','Update')){ return (New-NinjaOnePATCHRequest -Resource 'v2/knowledgebase/articles' -Body $articles) }
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}









