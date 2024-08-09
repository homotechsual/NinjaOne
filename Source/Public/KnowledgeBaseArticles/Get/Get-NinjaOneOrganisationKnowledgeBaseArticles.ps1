
function Get-NinjaOneOrganisationKnowledgeBaseArticles {
	<#
		.SYNOPSIS
			Gets knowledge base articles for organisations from the NinjaOne API.
		.DESCRIPTION
			Retrieves knowledge base articles for organisations from the NinjaOne v2 API.
		.FUNCTIONALITY
			Organisation Knowledge Base Articles
		.EXAMPLE
			PS> Get-NinjaOneOrganisationKnowledgeBaseArticles

			Gets all knowledge base articles for organisations.
		.EXAMPLE
			PS> Get-NinjaOneOrganisationKnowledgeBaseArticles -articleName 'Article Name'

			Gets all knowledge base articles for organisations with the name 'Article Name'.
		.EXAMPLE
			PS> Get-NinjaOneOrganisationKnowledgeBaseArticles -organisationIds '1,2,3'

			Gets all knowledge base articles for organisations with ids 1, 2, and 3.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationknowledgebasearticles
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnookba', 'Get-NinjaOneOrganizationKnowledgeBaseArticles')]
	[MetadataAttribute(
		'/v2/knowledgebase/organization/articles',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# The knowledge base article name to get.
		[Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[String]$articleName,
		# The organisation ids to get knowledge base articles for. Use a comma separated list for multiple ids.
		[Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[String]$organisationIds
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			Write-Verbose 'Getting organisation knowledge base articles.'
			$Resource = 'v2/knowledgebase/organization/articles'
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$OrganisationKnowledgeBaseArticlesResults = New-NinjaOneGETRequest @RequestParams
			return $OrganisationKnowledgeBaseArticlesResults
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}