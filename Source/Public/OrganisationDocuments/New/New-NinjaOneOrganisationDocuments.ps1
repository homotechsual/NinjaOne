function New-NinjaOneOrganisationDocuments {
	<#
		.SYNOPSIS
			Creates new organisation documents using the NinjaOne API.
		.DESCRIPTION
			Create one or more organisation documents using the NinjaOne v2 API.
		.FUNCTIONALITY
			Organisation Documents
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @(
				@{
					documentName = "string"
					documentTemplateId = 0
					fields = @{
						additionalProp1 = @{
						}
					}
					organizationId = 0
					documentDescription = "string"
				}
			)
			PS> New-NinjaOneOrganisationDocuments -organisationDocuments $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/organisationdocument
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnood', 'New-NinjaOneOrganizationDocument')]
	[MetadataAttribute(
		'/v2/organization/documents',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# An object containing an array of organisation documents to create.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('organizationDocuments', 'body')]
		[Object[]]$organisationDocuments,
		# Show the organisation documents that were created.
		[Switch]$show
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
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
			$Resource = 'v2/organization/documents'
			$RequestParams = @{
				Resource = $Resource
				Body = $organisationDocuments
				QSCollection = $QSCollection
			}
			if ($PSCmdlet.ShouldProcess(('Organisation documents for organisation(s) {0}' -f $organisationDocuments.organizationId), 'Create')) {
				$OrganisationDocumentsCreate = New-NinjaOnePOSTRequest @RequestParams
				if ($show) {
					return $OrganisationDocumentsCreate
				} else {
					Write-Information ('Organisation documents for {0} created.' -f $OrganisationDocumentsCreate.organizationId)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}










