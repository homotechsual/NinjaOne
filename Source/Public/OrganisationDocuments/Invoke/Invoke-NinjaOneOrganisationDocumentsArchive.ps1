<#
	.SYNOPSIS
		Archive organisation documents.

	.DESCRIPTION
		Archive organisation documents using the NinjaOne v2 API.

	.FUNCTIONALITY
		Archive Organisation Documents
	
	.EXAMPLE
		PS> Invoke-NinjaOneOrganisationDocumentsArchive -Identity 123

		Invokes the specified operation.

#>
function Invoke-NinjaOneOrganisationDocumentsArchive {
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[OutputType([Object])]
	[Alias('inOodsA')]
	[MetadataAttribute(
		'/v2/organization/documents/archive',
		'post'
	)]
	param(
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$request
	)
	process { try { if($PSCmdlet.ShouldProcess('Organisation Documents','Archive')){ return (New-NinjaOnePOSTRequest -Resource 'v2/organization/documents/archive' -Body $request) } } catch { New-NinjaOneError -ErrorRecord $_ } }
}

