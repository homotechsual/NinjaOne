function Set-NinjaOneOrganisationDocuments {
	<#
		.SYNOPSIS
			Sets one or more organisation documents.
		.DESCRIPTION
			Sets one or more organisation documents using the NinjaOne v2 API.
		.FUNCTIONALITY
			Organisation Documents
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/organisationdocument
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snoods', 'Set-NinjaOneOrganizationDocuments', 'unoods', 'Update-NinjaOneOrganisationDocuments', 'Update-NinjaOneOrganizationDocuments')]
	[MetadataAttribute(
		'/v2/organization/documents',
		'patch'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The organisation documents to update.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('organizationDocuments', 'body')]
		[NinjaOneOrganisationDocument[]]$organisationDocuments
	)
	begin {	}
	process {
		try {
			foreach ($Document in $organisationDocuments) {
				$Resource = ('v2/organization/documents' -f $organisationId, $documentId)
				$RequestParams = @{
					Resource = $Resource
					Body = $organisationDocuments
				}
			}
			if ($PSCmdlet.ShouldProcess('Organisation documents', 'Update')) {
				$OrganisationDocumentsUpdate = New-NinjaOnePATCHRequest @RequestParams
				if ($OrganisationDocumentsUpdate -eq 204) {
					Write-Information ('Organisation documents updated successfully.')
				} else {
					return $OrganisationDocumentsUpdate
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
