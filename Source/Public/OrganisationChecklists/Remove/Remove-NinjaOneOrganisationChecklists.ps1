function Remove-NinjaOneOrganisationChecklists {
	<#
		.SYNOPSIS
			Deletes organisation checklists.
		.DESCRIPTION
			Deletes organisation checklists via the NinjaOne v2 API.
		.FUNCTIONALITY
			Organisation Checklists
		.EXAMPLE
			PS> Remove-NinjaOneOrganisationChecklists -request @{ checklistIds = @(1,2) } -Confirm:$false

			Deletes the specified organisation checklists.
		.OUTPUTS
			Status code (204) on success.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/organisationchecklists
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[OutputType([Object])]
	[Alias('rnOoCls')]
	[MetadataAttribute(
		'/v2/organization/checklists/delete',
		'post'
	)]
	param(
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$request
	)
	process { try { if($PSCmdlet.ShouldProcess('Organisation Checklists','Delete')){ return (New-NinjaOnePOSTRequest -Resource 'v2/organization/checklists/delete' -Body $request) } } catch { New-NinjaOneError -ErrorRecord $_ } }
}
