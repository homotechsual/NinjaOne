function Set-NinjaOneChecklistTemplates {
	<#
		.SYNOPSIS
			Updates checklist templates.
		.DESCRIPTION
			Updates checklist templates via the NinjaOne v2 API.
		.FUNCTIONALITY
			Checklist Templates
		.EXAMPLE
			PS> Set-NinjaOneChecklistTemplates -templates @{ templates = @(@{ id=1; name='New' }) }

			Updates the specified templates.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/checklisttemplates
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[OutputType([Object])]
	[Alias('snocltm')]
	[MetadataAttribute(
		'/v2/checklist/templates',
		'put'
	)]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$templates
	)
	process { try { if($PSCmdlet.ShouldProcess('Checklist Templates','Update')){ return (New-NinjaOnePUTRequest -Resource 'v2/checklist/templates' -Body $templates) } } catch { New-NinjaOneError -ErrorRecord $_ } }
}
