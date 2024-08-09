
function Get-NinjaOneRelatedItemAttachment {
	<#
		.SYNOPSIS
			Gets a related item attachment from the NinjaOne API.
		.DESCRIPTION
			Retrieves a related item attachment from the NinjaOne v2 API.
		.FUNCTIONALITY
			Related Item Attachment
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
	[Alias('gnoria')]
	[MetadataAttribute(
		'/v2/related-items/{relatedItemId}/attachment/download',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# The related item id to get the attachment for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$relatedItemId
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		# Workaround to prevent the query string processor from adding a 'relatedItemId=' parameter by removing it from the set parameters.
		$Parameters.Remove('relatedItemId') | Out-Null
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			Write-Verbose ('Getting related item attachment download for id {0}.' -f $articleId)
			$Resource = ('v2/related-items/{0}/attachment/download' -f $relatedItemId)
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$RelatedItemAttachmentResults = New-NinjaOneGETRequest @RequestParams
			return $RelatedItemAttachmentResults
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}