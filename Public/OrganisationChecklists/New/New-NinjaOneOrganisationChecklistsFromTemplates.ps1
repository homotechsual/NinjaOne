function New-NinjaOneOrganisationChecklistsFromTemplates {
	<#
		.SYNOPSIS
			Creates organisation checklists from templates.
		.DESCRIPTION
			Creates organisation checklists from templates via the NinjaOne v2 API.
		.FUNCTIONALITY
			Organisation Checklists
		.EXAMPLE
			PS> New-NinjaOneOrganisationChecklistsFromTemplates -organisationId 1 -request @{ templateIds = @(10,11) }

			Creates checklists for organisation 1 from templates 10 and 11.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/organisationchecklists-from-templates
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnoocltf')]
	[MetadataAttribute(
		'/v2/organization/{organizationId}/checklists-from-templates',
		'post'
	)]
	Param(
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$organisationId,
		# Request payload per API schema
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$request
	)
	process {
		try {
			$Resource = ('v2/organization/{0}/checklists-from-templates' -f $organisationId)
			$RequestParams = @{ Resource = $Resource; Body = $request }
			if ($PSCmdlet.ShouldProcess(('Organisation {0}' -f $organisationId), 'Create Checklists From Templates')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

