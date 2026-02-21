<#
	.SYNOPSIS
		Restore an organisation.
	.DESCRIPTION
		Restore organisation using the NinjaOne v2 API.
	.FUNCTIONALITY
		Restore Organisation
	
	.EXAMPLE
		PS> Invoke-NinjaOneOrganisationRestore -Identity 123

		Invokes the specified operation.

#>
function Invoke-NinjaOneOrganisationRestore {
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[OutputType([Object])]
	[Alias('inOoR')]
	[MetadataAttribute(
		'/v2/organization/restore',
		'post'
	)]
	param(
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$request
	)
	process { try { if($PSCmdlet.ShouldProcess('Organisations','Restore')){ return (New-NinjaOnePOSTRequest -Resource 'v2/organization/restore' -Body $request) } } catch { New-NinjaOneError -ErrorRecord $_ } }
}

