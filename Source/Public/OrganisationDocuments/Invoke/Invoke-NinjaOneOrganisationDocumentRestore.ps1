<#
	.SYNOPSIS
		Restore an organisation document.

	.FUNCTIONALITY
		Restore Organisation Document
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

