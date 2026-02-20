
function Get-NinjaOneGlobalKnowledgeBaseArticles {
	<#
		.SYNOPSIS
			Gets global knowledge base articles from the NinjaOne API.
		.DESCRIPTION
			Retrieves global knowledge base articles from the NinjaOne v2 API.
		.FUNCTIONALITY
			Global Knowledge Base Articles
		.EXAMPLE
			PS> Get-NinjaOneGlobalKnowledgeBaseArticles

			Gets all global knowledge base articles.
		.EXAMPLE
			PS> Get-NinjaOneGlobalKnowledgeBaseArticles -articleName 'Article Name'

			Gets all global knowledge base articles with the name 'Article Name'.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/globalknowledgebasearticles
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnogkba')]
	[MetadataAttribute(
		'/v2/knowledgebase/global/articles',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The knowledge base article name to get.
		[Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[String]$articleName
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			Write-Verbose 'Getting global knowledge base articles.'
			$Resource = 'v2/knowledgebase/global/articles'
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$GlobalKnowledgeBaseArticlesResults = New-NinjaOneGETRequest @RequestParams
			return $GlobalKnowledgeBaseArticlesResults
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
