<#
	.SYNOPSIS
		Restore an organisation document.
	.DESCRIPTION
		Restore organisation document using the NinjaOne v2 API.
	.FUNCTIONALITY
		Restore Organisation Document
	
	.EXAMPLE
		PS> Invoke-NinjaOneOrganisationDocumentRestore -Identity 123

		Invokes the specified operation.

#>
function Invoke-NinjaOneOrganisationDocumentRestore {
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[OutputType([Object])]
	[Alias('inOodR')]
	[MetadataAttribute(
		'/v2/organization/document/{clientDocumentId}/restore',
		'post'
	)]
	param(
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Int]$clientDocumentId
	)
	process { try { $res='v2/organization/document/{0}/restore' -f $clientDocumentId; if($PSCmdlet.ShouldProcess(('Organisation Document {0}' -f $clientDocumentId),'Restore')){ return (New-NinjaOnePOSTRequest -Resource $res) } } catch { New-NinjaOneError -ErrorRecord $_ } }
}

