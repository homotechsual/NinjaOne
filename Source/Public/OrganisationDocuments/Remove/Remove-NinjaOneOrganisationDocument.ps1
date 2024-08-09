function Remove-NinjaOneOrganisationDocument {
	<#
		.SYNOPSIS
			Removes an organisation document using the NinjaOne API.
		.DESCRIPTION
			Removes the specified organisation document using the NinjaOne v2 API.
		.FUNCTIONALITY
			Organisation Document
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/organisationdocument
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('rnood', 'Remove-NinjaOneOrganizationDocument')]
	[MetadataAttribute(
		'/v2/organization/document/{clientDocumentId}',
		'delete'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# The organisation document to delete.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id', 'documentId', 'organisationDocumentId', 'organizationDocument')]
		[Int]$clientDocumentId
	)
	process {
		try {
			$Resource = ('v2/organization/document/{0}' -f $clientDocumentId)
			$RequestParams = @{
				Resource = $Resource
			}
			if ($PSCmdlet.ShouldProcess(('Organisation Document {0}' -f $clientDocumentId), 'Delete')) {
				$OrganisationDocumentDelete = New-NinjaOneDELETERequest @RequestParams
				if ($OrganisationDocumentDelete -eq 204) {
					Write-Information ('Organisation Document {0} deleted successfully.' -f $clientDocumentId)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}