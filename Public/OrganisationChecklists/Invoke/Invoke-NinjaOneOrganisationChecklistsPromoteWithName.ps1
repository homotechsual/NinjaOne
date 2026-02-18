function Invoke-NinjaOneOrganisationChecklistsPromoteWithName {
	<#
		.SYNOPSIS
			Promotes organisation checklists with a new name.
		.DESCRIPTION
			Promotes organisation checklists assigning a new name via the NinjaOne v2 API.
		.FUNCTIONALITY
			Organisation Checklists
		.EXAMPLE
			PS> Invoke-NinjaOneOrganisationChecklistsPromoteWithName -request @{ checklistIds=@(1); name='New Name' }

			Promotes checklists with a new name.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/organisationchecklists-promote-with-name
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[OutputType([Object])]
	[Alias('inOoClPromName')]
	[MetadataAttribute(
		'/v2/organization/checklists/promote-with-name',
		'post'
	)]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$request
	)
	process { try { if($PSCmdlet.ShouldProcess('Organisation Checklists','Promote With Name')){ return (New-NinjaOnePOSTRequest -Resource 'v2/organization/checklists/promote-with-name' -Body $request) } } catch { New-NinjaOneError -ErrorRecord $_ } }
}
