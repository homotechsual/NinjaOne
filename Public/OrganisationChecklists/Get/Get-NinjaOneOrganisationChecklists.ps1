function Get-NinjaOneOrganisationChecklists {
	<#
		.SYNOPSIS
			Gets organisation checklists.
		.DESCRIPTION
			Retrieves organisation checklists via the NinjaOne v2 API.
		.FUNCTIONALITY
			Organisation Checklists
		.EXAMPLE
			PS> Get-NinjaOneOrganisationChecklists

			Gets organisation checklists.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationchecklists
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnoocl', 'Get-NinjaOneOrganizationChecklists')]
	[MetadataAttribute(
		'/v2/organization/checklists',
		'get'
	)]
	Param()
	process {
		try {
			$Resource = 'v2/organization/checklists'
			$RequestParams = @{ Resource = $Resource }
			$Results = New-NinjaOneGETRequest @RequestParams
			if ($Results) {
				return $Results
			} else {
				throw 'No organisation checklists found.'
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
