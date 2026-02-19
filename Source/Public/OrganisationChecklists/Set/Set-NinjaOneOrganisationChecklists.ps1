function Set-NinjaOneOrganisationChecklists {
	<#
		.SYNOPSIS
			Updates organisation checklists.
		.DESCRIPTION
			Updates organisation checklists via the NinjaOne v2 API.
		.FUNCTIONALITY
			Organisation Checklists
		.EXAMPLE
			PS> Set-NinjaOneOrganisationChecklists -checklists @{ ... }

			Updates organisation checklists.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/organisationchecklists
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[OutputType([Object])]
	[Alias('snoocl')]
	[MetadataAttribute(
		'/v2/organization/checklists',
		'put'
	)]
	param(
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$checklists
	)
	process { try { if($PSCmdlet.ShouldProcess('Organisation Checklists','Update')){ return (New-NinjaOnePUTRequest -Resource 'v2/organization/checklists' -Body $checklists) } } catch { New-NinjaOneError -ErrorRecord $_ } }
}
