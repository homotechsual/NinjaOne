<#
	.SYNOPSIS
		Restore document templates.

	.DESCRIPTION
		Restore document templates using the NinjaOne v2 API.

	.FUNCTIONALITY
		Restore Document Templates
	
	.EXAMPLE
		PS> Invoke-NinjaOneDocumentTemplatesRestore -Identity 123

		Invokes the specified operation.

#>
function Invoke-NinjaOneDocumentTemplatesRestore {
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[OutputType([Object])]
	[Alias('inodtrs')]
	[MetadataAttribute(
		'/v2/document-templates/restore',
		'post'
	)]
	param(
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$request
	)
	process { try { if($PSCmdlet.ShouldProcess('Document Templates','Restore')){ return (New-NinjaOnePOSTRequest -Resource 'v2/document-templates/restore' -Body $request) } } catch { New-NinjaOneError -ErrorRecord $_ } }
}

