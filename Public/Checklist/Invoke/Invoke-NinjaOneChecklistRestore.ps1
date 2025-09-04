function Invoke-NinjaOneChecklistRestore {
	<#
		.SYNOPSIS
			Restores archived checklists.
		.DESCRIPTION
			Restores archived checklists via the NinjaOne v2 API.
		.FUNCTIONALITY
			Checklist Templates
		.EXAMPLE
			PS> Invoke-NinjaOneChecklistRestore -request @{ checklistIds = @(1,2) }

			Restores the specified checklists.
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
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$request
	)
	process { try { if($PSCmdlet.ShouldProcess('Checklists','Restore')){ return (New-NinjaOnePOSTRequest -Resource 'v2/checklist/restore' -Body $request) } } catch { New-NinjaOneError -ErrorRecord $_ } }
}
