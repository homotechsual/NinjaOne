function Invoke-NinjaOneChecklistArchive {
	<#
		.SYNOPSIS
			Archives checklists.
		.DESCRIPTION
			Archives one or more checklists via the NinjaOne v2 API.
		.FUNCTIONALITY
			Checklist Archive
		.EXAMPLE
			PS> Invoke-NinjaOneChecklistArchive -checklistsToArchive @{ checklistTemplateIds = @(1,2) }

			Archives the specified checklists.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				checklistTemplateIds = @(
					0
				)
			}
			PS> Invoke-NinjaOneChecklistArchive -checklistsToArchive $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			Status code or job result per API.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/checklist-archive
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[OutputType([Object])]
	[Alias('inoclarch')]
	[MetadataAttribute(
		'/v2/checklist/archive',
		'post'
	)]
	param(
		# The checklist IDs to archive.
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$checklistsToArchive
	)
	process { try { if($PSCmdlet.ShouldProcess('Checklists','Archive')){ return (New-NinjaOnePOSTRequest -Resource 'v2/checklist/archive' -Body $request) } } catch { New-NinjaOneError -ErrorRecord $_ } }
}








