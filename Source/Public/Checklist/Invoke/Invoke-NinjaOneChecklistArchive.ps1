function Invoke-NinjaOneChecklistArchive {
	<#
		.SYNOPSIS
			Archives checklists.
		.DESCRIPTION
			Archives one or more checklists via the NinjaOne v2 API.
		.FUNCTIONALITY
			Checklist Templates
		.EXAMPLE
			PS> Invoke-NinjaOneChecklistArchive -request @{ checklistIds = @(1,2) }

			Archives the specified checklists.
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
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$request
	)
	process { try { if($PSCmdlet.ShouldProcess('Checklists','Archive')){ return (New-NinjaOnePOSTRequest -Resource 'v2/checklist/archive' -Body $request) } } catch { New-NinjaOneError -ErrorRecord $_ } }
}
