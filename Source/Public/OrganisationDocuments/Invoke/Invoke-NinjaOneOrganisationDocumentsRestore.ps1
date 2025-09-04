function Invoke-NinjaOneOrganisationDocumentsRestore {
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[OutputType([Object])]
	[Alias('inOodsR')]
	[MetadataAttribute(
		'/v2/organization/documents/restore',
		'post'
	)]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$request
	)
	process { try { if($PSCmdlet.ShouldProcess('Organisation Documents','Restore')){ return (New-NinjaOnePOSTRequest -Resource 'v2/organization/documents/restore' -Body $request) } } catch { New-NinjaOneError -ErrorRecord $_ } }
}

