function Get-NinjaOneCustomFieldSignedURLs {
	<#
		.SYNOPSIS
			Gets custom field signed URLs from the NinjaOne API.
		.DESCRIPTION
			Retrieves custom field signed URLs from the NinjaOne v2 API.
		.FUNCTIONALITY
			Custom Field Signed URLs
		.EXAMPLE
			Get-NinjaOneCustomFieldSignedURLs -entityType 'ORGANIZATION' -entityId 1

			Gets signed URLs for the custom fields of the ORGANIZATION entity with id 1.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/customfieldsignedurls
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnoodsu', 'Get-NinjaOneOrganizationDocumentSignedURLs')]
	[MetadataAttribute(
		'/v2/organization/document/{clientDocumentId}/signed-urls',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
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
			Write-Verbose ('Getting signed URLs for custom field with id {0}.' -f $clientDocumentId)
			$Resource = ('v2/organization/document/{0}/signed-urls' -f $clientDocumentId)
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$OrganisationDocumentSignedURLsResults = New-NinjaOneGETRequest @RequestParams
			if ($OrganisationDocumentSignedURLsResults) {
				return $OrganisationDocumentSignedURLsResults
			} else {
				throw ('No custom field signed URLs found for custom field {0}.' -f $clientDocumentId)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
