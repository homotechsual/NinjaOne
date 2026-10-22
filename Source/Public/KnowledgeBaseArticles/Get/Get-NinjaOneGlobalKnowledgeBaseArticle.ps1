function Get-NinjaOneGlobalKnowledgeBaseArticle {
	<#
		.SYNOPSIS
			Gets a global knowledge base article from the NinjaOne API.
		.DESCRIPTION
			Retrieves a specific global knowledge base article object by id.
		.FUNCTIONALITY
			Global Knowledge Base Article
		.EXAMPLE
			PS> Get-NinjaOneGlobalKnowledgeBaseArticle -articleId 1

			Gets the global knowledge base article with id 1.
		.OUTPUTS
			A PowerShell object containing the article.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/globalknowledgebasearticle
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnogkbad')]
	[MetadataAttribute('/v2/knowledgebase/global/article/{articleId}', 'get')]
	param(
		# The global knowledge base article id to get.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$articleId
	)
	process {
		try {
			Write-Verbose ('Getting global knowledge base article with id {0}.' -f $articleId)
			$Resource = ('v2/knowledgebase/global/article/{0}' -f $articleId)
			return New-NinjaOneGETRequest -Resource $Resource
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
