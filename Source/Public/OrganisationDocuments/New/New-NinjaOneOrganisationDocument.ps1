function New-NinjaOneOrganisationDocument {
	<#
		.SYNOPSIS
			Creates a new organisation document using the NinjaOne API.
		.DESCRIPTION
			Create a single organisation document using the NinjaOne v2 API.
		.FUNCTIONALITY
			Organisation Document
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/organisationdocument
	
	.EXAMPLE
		PS> $newObject = @{ Name = 'Example' }
		PS> New-NinjaOneOrganisationDocument @newObject

		Creates a new resource with the specified properties.

	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnood', 'New-NinjaOneOrganizationDocument')]
	[MetadataAttribute(
		'/v2/organization/{organizationId}/template/{documentTemplateId}/document',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The Id of the organisation to create the document for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('organizationId', 'id')]
		[String]$organisationId,
		# The Id of the document template to use.
		[Parameter(Mandatory, Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('templateId')]
		[String]$documentTemplateId,
		# An object containing an array of organisation documents to create.
		[Parameter(Mandatory, Position = 2, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('organizationDocuments', 'organisationDocuments', 'organizationDocument', 'body')]
		[Object]$organisationDocument,
		# Show the organisation document that was created.
		[Switch]$show
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		# Workaround to prevent the query string processor from adding an 'organisationId=' parameter by removing it from the set parameters.
		if ($organisationId) {
			$Parameters.Remove('organisationId') | Out-Null
		}
		# Workaround to prevent the query string processor from adding a 'documentTemplateId=' parameter by removing it from the set parameters.
		if ($documentTemplateId) {
			$Parameters.Remove('documentTemplateId') | Out-Null
		}
		# Workaround to prevent the query string processor from adding an 'organisationDocuments=' parameter by removing it from the set parameters.
		if ($organisationDocuments) {
			$Parameters.Remove('organisationDocuments') | Out-Null
		}
		# Workaround to prevent the query string processor from adding a 'show=' parameter by removing it from the set parameters.
		if ($show) {
			$Parameters.Remove('show') | Out-Null
		}
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			$Resource = ('v2/organization/{0}/template/{1}/document' -f $organisationId, $documentTemplateId)
			$RequestParams = @{
				Resource = $Resource
				Body = $organisationDocuments
				QSCollection = $QSCollection
			}
			if ($PSCmdlet.ShouldProcess(('Organisation document for organisation {0}' -f $organisationId), 'Create')) {
				$OrganisationDocumentCreate = New-NinjaOnePOSTRequest @RequestParams
				if ($show) {
					return $OrganisationDocumentCreate
				} else {
					Write-Information ('Organisation document for {0} created.' -f $organisationId)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
