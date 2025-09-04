function Invoke-NinjaOneDocumentTemplatesArchive {
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[OutputType([Object])]
	[Alias('inodtas')]
	[MetadataAttribute(
		'/v2/document-templates/archive',
		'post'
	)]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$request
	)
	process { try { if($PSCmdlet.ShouldProcess('Document Templates','Archive')){ return (New-NinjaOnePOSTRequest -Resource 'v2/document-templates/archive' -Body $request) } } catch { New-NinjaOneError -ErrorRecord $_ } }
}

