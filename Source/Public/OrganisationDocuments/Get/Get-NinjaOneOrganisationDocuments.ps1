function Get-NinjaOneOrganisationDocuments {
	<#
		.SYNOPSIS
			Gets organisation documents from the NinjaOne API.
		.DESCRIPTION
			Retrieves organisation documents from the NinjaOne v2 API.
		.FUNCTIONALITY
			Organisation Documents
		.EXAMPLE
			Get-NinjaOneOrganisationDocuments -organisationId 1

			Gets documents for the organisation with id 1.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationdocuments
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnood', 'Get-NinjaOneOrganizationDocuments')]
	[MetadataAttribute(
		'/v2/organization/{organizationId}/documents',
		'get',
		'/v2/organization/documents',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# Filter by organisation id.
		[Parameter(Mandatory, ParameterSetName = 'Single Organisation', Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id', 'organizationId')]
		[Int]$organisationId,
		# Filter by document name.
		[Parameter(ParameterSetName = 'All Organisations', Position = 1, ValueFromPipelineByPropertyName)]
		[String]$documentName,
		# Group by template or organisation.
		[Parameter(ParameterSetName = 'All Organisations', Position = 2, ValueFromPipelineByPropertyName)]
		[ValidateSet('template', 'organization')]
		[String]$groupBy,
		# Filter by organisation ids. Comma separated list of organisation ids.
		[Parameter(ParameterSetName = 'All Organisations', Position = 3, ValueFromPipelineByPropertyName)]
		[String]$organisationIds,
		# Filter by template ids. Comma separated list of template ids.
		[Parameter(ParameterSetName = 'All Organisations', Position = 4, ValueFromPipelineByPropertyName)]
		[String]$templateIds,
		# Filter by template name.
		[Parameter(ParameterSetName = 'All Organisations', Position = 5, ValueFromPipelineByPropertyName)]
		[String]$templateName

	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		# Workaround to prevent the query string processor from adding an 'organisationid=' parameter by removing it from the set parameters.
		if ($organisationId) {
			$Parameters.Remove('organisationId') | Out-Null
		}
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			Write-Verbose 'Getting organisation documents from NinjaOne API.'
			if ($PSCmdlet.ParameterSetName -eq 'Single Organisation') {
				Write-Verbose ('Getting documents for organisation {0}.' -f $organisationId)
				$Resource = ('v2/organization/{0}/documents' -f $organisationId)
			} elseif ($PSCmdlet.ParameterSetName -eq 'All Organisations') {
				Write-Verbose 'Getting documents for all organisations.'
				$Resource = 'v2/organization/documents'
			}
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$OrganisationDocumentResults = New-NinjaOneGETRequest @RequestParams
			if ($OrganisationDocumentResults) {
				return $OrganisationDocumentResults
			} else {
				throw ('No documents found for organisation {0}.' -f $organisationId)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}