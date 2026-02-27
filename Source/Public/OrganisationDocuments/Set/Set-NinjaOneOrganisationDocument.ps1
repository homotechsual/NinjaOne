function Set-NinjaOneOrganisationDocument {
	<#
		.SYNOPSIS
			Sets an organisation document.
		.DESCRIPTION
			Sets organisation documents using the NinjaOne v2 API.
		.FUNCTIONALITY
			Organisation Document
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				documentName = "string"
				documentDescription = "string"
				fields = @{
					additionalProp1 = @{
					}
				}
			}
			PS> Set-NinjaOneOrganisationDocument -clientDocumentId 1 -organisationDocument $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/organisationdocument
	
	.EXAMPLE
		PS> Set-NinjaOneOrganisationDocument -Identity 123 -Property 'Value'

		Updates the specified resource.

	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snood', 'Set-NinjaOneOrganizationDocument', 'unood', 'Update-NinjaOneOrganisationDocument', 'Update-NinjaOneOrganizationDocument')]
	[MetadataAttribute(
		'/v2/organization/{organizationId}/document/{clientDocumentId}',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The organisation to set the information for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id', 'organizationId')]
		[Int]$organisationId,
		# The organisation document id to update.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('documentId')]
		[Int]$clientDocumentId,
		# The organisation information body object.
		[Parameter(Mandatory, Position = 2, ValueFromPipelineByPropertyName)]
		[Alias('organizationDocument', 'body')]
		[Object]$organisationDocument
	)
	begin { }
	process {
		try {
			Write-Verbose ('Setting organisation document for organisation {0}.' -f $organisationId)
			$Resource = ('v2/organization/{0}/document/{1}' -f $organisationId, $documentId)
			$RequestParams = @{
				Resource = $Resource
				Body = $organisationDocument
			}
			if ($PSCmdlet.ShouldProcess(('Organisation {0} document {1}' -f $organisationId, $clientDocumentId), 'Update')) {
				$OrganisationDocumentUpdate = New-NinjaOnePOSTRequest @RequestParams
				if ($OrganisationDocumentUpdate -eq 204) {
					Write-Information ('Organisation {0} document {1} updated successfully.' -f $organisationId, $clientDocumentId)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}









