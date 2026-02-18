function Invoke-NinjaOneDocumentTemplateArchive {
	<#
		.SYNOPSIS
			Archives a document template.
		.DESCRIPTION
			Archives a document template via the NinjaOne v2 API.
		.FUNCTIONALITY
			Document Templates
		.EXAMPLE
			PS> Invoke-NinjaOneDocumentTemplateArchive -documentTemplateId 10

			Archives template 10.
		.OUTPUTS
			Status code or job result per API.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/documenttemplate-archive
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[OutputType([Object])]
	[Alias('inodta')]
	[MetadataAttribute(
		'/v2/document-templates/{documentTemplateId}/archive',
		'post'
	)]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Int]$documentTemplateId
	)
	process { try { $res='v2/document-templates/{0}/archive' -f $documentTemplateId; if($PSCmdlet.ShouldProcess(('Document Template {0}' -f $documentTemplateId),'Archive')){ return (New-NinjaOnePOSTRequest -Resource $res) } } catch { New-NinjaOneError -ErrorRecord $_ } }
}
