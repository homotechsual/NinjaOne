
function Get-NinjaOneKnowledgeBaseArticle {
	<#
		.SYNOPSIS
			Gets a knowledge base article from the NinjaOne API.
		.DESCRIPTION
			Retrieves a knowledge base article from the NinjaOne v2 API.
		.FUNCTIONALITY
			Knowledge Base Article
		.EXAMPLE
			PS> Get-NinjaOneKnowledgeBaseArticle -articleId 1

			Gets the knowledge base article with id 1.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/knowledgebasearticle
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnokba')]
	[MetadataAttribute(
		'/v2/knowledgebase/article/{articleId}/download',
		'get',
		'/v2/knowledgebase/article/{articleId}/signed-urls',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The knowledge base article id to get.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$articleId,
		# Get a map of content ids and their corresponding signed urls.
		[Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Switch]$signedUrls
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		# Workaround to prevent the query string processor from adding an 'articleId=' parameter by removing it from the set parameters.
		$Parameters.Remove('articleId') | Out-Null
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			if (!$signedUrls) {
				Write-Verbose ('Getting knowledge base article with id {0}.' -f $articleId)
				$Resource = ('v2/knowledgebase/article/{0}/download' -f $articleId)
			} elseif ($signedUrls) {
				Write-Verbose ('Getting signed urls for knowledge base article with id {0}.' -f $articleId)
				$Resource = ('v2/knowledgebase/article/{0}/signed-urls' -f $articleId)
			}
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$KnowledgeBaseArticleResults = New-NinjaOneGETRequest @RequestParams
			return $KnowledgeBaseArticleResults
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
