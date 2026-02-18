function Invoke-NinjaOneOrganisationRestore {
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[OutputType([Object])]
	[Alias('inOoR')]
	[MetadataAttribute(
		'/v2/organization/restore',
		'post'
	)]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$request
	)
	process { try { if($PSCmdlet.ShouldProcess('Organisations','Restore')){ return (New-NinjaOnePOSTRequest -Resource 'v2/organization/restore' -Body $request) } } catch { New-NinjaOneError -ErrorRecord $_ } }
}

