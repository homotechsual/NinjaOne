function Get-NinjaOneOrganisationDocumentSignedURLs {
	<#
		.SYNOPSIS
			Gets organisation document signed URLs from the NinjaOne API.
		.DESCRIPTION
			Retrieves organisation document signed URLs from the NinjaOne v2 API.
		.FUNCTIONALITY
			Organisation Document Signed URLs
		.EXAMPLE
			Get-NinjaOneOrganisationDocumentSignedURLs -clientDocumentId 1

			Gets signed URLs for the organisation document with id 1.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationdocumentsignedurls
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnoodsu', 'Get-NinjaOneOrganizationDocumentSignedURLs')]
	[MetadataAttribute(
		'/v2/organization/document/{clientDocumentId}/signed-urls',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# The client document id to get signed URLs for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id', 'documentId', 'organisationDocumentId', 'organizationDocumentId')]
		[Int]$clientDocumentId
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		# Workaround to prevent the query string processor from adding an 'clientdocumentid=' parameter by removing it from the set parameters.
		if ($clientDocumentId) {
			$Parameters.Remove('clientDocumentId') | Out-Null
		}
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			Write-Verbose ('Getting signed URLs for organisation document with id {0}.' -f $clientDocumentId)
			$Resource = ('v2/organization/document/{0}/signed-urls' -f $clientDocumentId)
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$OrganisationDocumentSignedURLsResults = New-NinjaOneGETRequest @RequestParams
			if ($OrganisationDocumentSignedURLsResults) {
				return $OrganisationDocumentSignedURLsResults
			} else {
				throw ('No organisation document signed URLs found for organisation document {0}.' -f $clientDocumentId)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}