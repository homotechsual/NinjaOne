function Remove-NinjaOneChecklistTemplates {
	<#
		.SYNOPSIS
			Deletes checklist templates.
		.DESCRIPTION
			Deletes one or more checklist templates via the NinjaOne v2 API.
		.FUNCTIONALITY
			Checklist Templates
		.EXAMPLE
			PS> Remove-NinjaOneChecklistTemplates -templateIds @(1,2) -Confirm:$false

			Deletes templates 1 and 2.
		.OUTPUTS
			Status code (204) on success.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/checklisttemplates
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[OutputType([Object])]
	[Alias('rnocltm')]
	[MetadataAttribute(
		'/v2/checklist/templates/delete',
		'post'
	)]
	param(
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Int[]]$templateIds
	)
	process { try { if($PSCmdlet.ShouldProcess('Checklist Templates','Delete')){ return (New-NinjaOnePOSTRequest -Resource 'v2/checklist/templates/delete' -Body $templateIds) } } catch { New-NinjaOneError -ErrorRecord $_ } }
}
