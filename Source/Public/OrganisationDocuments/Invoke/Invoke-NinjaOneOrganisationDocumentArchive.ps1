<#
	.SYNOPSIS
		Archive an organisation document.
	.DESCRIPTION
		Archive organisation document using the NinjaOne v2 API.
	.FUNCTIONALITY
		Archive Organisation Document
	
	.EXAMPLE
		PS> Invoke-NinjaOneOrganisationDocumentArchive -Identity 123

		Invokes the specified operation.

#>
function Invoke-NinjaOneOrganisationDocumentArchive {
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[OutputType([Object])]
	[Alias('inOodA')]
	[MetadataAttribute(
		'/v2/organization/document/{clientDocumentId}/archive',
		'post'
	)]
	param(
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Int]$clientDocumentId
	)
	process { try { $res='v2/organization/document/{0}/archive' -f $clientDocumentId; if($PSCmdlet.ShouldProcess(('Organisation Document {0}' -f $clientDocumentId),'Archive')){ return (New-NinjaOnePOSTRequest -Resource $res) } } catch { New-NinjaOneError -ErrorRecord $_ } }
}

