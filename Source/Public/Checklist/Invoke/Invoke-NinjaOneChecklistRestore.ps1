function Invoke-NinjaOneChecklistRestore {
	<#
		.SYNOPSIS
			Restores archived checklists.
		.DESCRIPTION
			Restores archived checklists via the NinjaOne v2 API.
		.FUNCTIONALITY
			Checklist Restore
		.EXAMPLE
			PS> Invoke-NinjaOneChecklistRestore -checklistsToRestore @{ checklistTemplateIds = @(1,2) }

			Restores the specified checklists.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				checklistTemplateIds = @(
					0
				)
			}
			PS> Invoke-NinjaOneChecklistRestore -checklistsToRestore $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			Status code or job result per API.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/checklist-restore
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[OutputType([Object])]
	[Alias('inoclrest')]
	[MetadataAttribute(
		'/v2/checklist/restore',
		'post'
	)]
	param(
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$checklistsToRestore
	)
	process { try { if($PSCmdlet.ShouldProcess('Checklists','Restore')){ return (New-NinjaOnePOSTRequest -Resource 'v2/checklist/restore' -Body $request) } } catch { New-NinjaOneError -ErrorRecord $_ } }
}







