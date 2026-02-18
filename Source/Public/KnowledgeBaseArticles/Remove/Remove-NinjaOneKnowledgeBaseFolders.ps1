function Remove-NinjaOneKnowledgeBaseFolders {
	<#
		.SYNOPSIS
			Deletes knowledge base folders.
		.DESCRIPTION
			Deletes knowledge base folders via the NinjaOne v2 API.
		.FUNCTIONALITY
			Knowledge Base Articles
		.EXAMPLE
			PS> Remove-NinjaOneKnowledgeBaseFolders -folderIds @(10,11) -Confirm:$false

			Deletes the specified folders.
		.OUTPUTS
			Status code (204) on success.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/kb-folders
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('rnokbf')]
	[MetadataAttribute(
		'/v2/knowledgebase/folders/delete',
		'post'
	)]
	Param(
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Int[]]$folderIds
	)
	process {
		try {
			$Resource = 'v2/knowledgebase/folders/delete'
			$RequestParams = @{ Resource = $Resource; Body = $folderIds }
			if ($PSCmdlet.ShouldProcess('Knowledge Base Folders', 'Delete')) {
				$Response = New-NinjaOnePOSTRequest @RequestParams
				return $Response
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

