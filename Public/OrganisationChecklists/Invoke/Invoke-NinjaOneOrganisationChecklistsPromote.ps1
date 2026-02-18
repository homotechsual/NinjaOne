function Invoke-NinjaOneOrganisationChecklistsPromote {
	<#
		.SYNOPSIS
			Promotes organisation checklists.
		.DESCRIPTION
			Promotes organisation checklists via the NinjaOne v2 API.
		.FUNCTIONALITY
			Organisation Checklists
		.EXAMPLE
			PS> Invoke-NinjaOneOrganisationChecklistsPromote -request @{ checklistIds=@(1,2) }

			Promotes the specified organisation checklists.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/organisationchecklists-promote
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[OutputType([Object])]
	[Alias('inOoClProm')]
	[MetadataAttribute(
		'/v2/organization/checklists/promote',
		'post'
	)]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$request
	)
	process { try { if($PSCmdlet.ShouldProcess('Organisation Checklists','Promote')){ return (New-NinjaOnePOSTRequest -Resource 'v2/organization/checklists/promote' -Body $request) } } catch { New-NinjaOneError -ErrorRecord $_ } }
}
