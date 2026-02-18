function Invoke-NinjaOneDocumentTemplateRestore {
	<#
		.SYNOPSIS
			Restores an archived document template.
		.DESCRIPTION
			Restores an archived document template via the NinjaOne v2 API.
		.FUNCTIONALITY
			Document Templates
		.EXAMPLE
			PS> Invoke-NinjaOneDocumentTemplateRestore -documentTemplateId 10

			Restores template 10.
		.OUTPUTS
			Status code or job result per API.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/documenttemplate-restore
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[OutputType([Object])]
	[Alias('inodtr')]
	[MetadataAttribute(
		'/v2/document-templates/{documentTemplateId}/restore',
		'post'
	)]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Int]$documentTemplateId
	)
	process { try { $res='v2/document-templates/{0}/restore' -f $documentTemplateId; if($PSCmdlet.ShouldProcess(('Document Template {0}' -f $documentTemplateId),'Restore')){ return (New-NinjaOnePOSTRequest -Resource $res) } } catch { New-NinjaOneError -ErrorRecord $_ } }
}
