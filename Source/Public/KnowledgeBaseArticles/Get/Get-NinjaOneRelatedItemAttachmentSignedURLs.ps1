
function Get-NinjaOneRelatedItemAttachmentSignedURLs {
	<#
		.SYNOPSIS
			Gets related item attachment signed URLs from the NinjaOne API.
		.DESCRIPTION
			Retrieves a related item attachment signed URLs from the NinjaOne v2 API.
		.FUNCTIONALITY
			Related Item Attachment Signed URLs
		.EXAMPLE
			PS> Get-NinjaOneRelatedItemAttachmentSignedURLs -entityType 'KB_DOCUMENT' -entityId 1

			Gets the related item attachment signed URLs for the KB_DOCUMENT entity with id 1.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/relateditemattachmentsignedurls
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnoriasu')]
[MetadataAttribute(
	'/v2/related-items/with-entity/{entityType}/{entityId}/attachments/signed-urls',
	'get'
)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# The entity type of the related item.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[ValidateSet('ORGANIZATION', 'DOCUMENT', 'LOCATION', 'NODE', 'CHECKLIST', 'KB_DOCUMENT')]
		[String]$entityType,
		# The entity id of the related item.
		[Parameter(Mandatory, Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$entityId
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		# Workaround to prevent the query string processor from adding an 'entityType=' parameter by removing it from the set parameters.
		$Parameters.Remove('entityType') | Out-Null
		# Workaround to prevent the query string processor from adding an 'entityId=' parameter by removing it from the set parameters.
		$Parameters.Remove('entityId') | Out-Null
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			Write-Verbose ('Getting related item attachment signed urls for {0} entity {1}.' -f $entityType, $entityId)
			$Resource = ('v2/related-items/with-entity/{0}/{1}/attachments/signed-urls' -f $entityType, $entityId)
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$RelatedItemAttachmentSignedURLsResults = New-NinjaOneGETRequest @RequestParams
			return $RelatedItemAttachmentSignedURLsResults
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
