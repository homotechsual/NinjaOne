function Restore-NinjaOneKnowledgeBaseFolders {
	<#
		.SYNOPSIS
			Restores archived knowledge base folders.
		.DESCRIPTION
			Restores archived knowledge base folders via the NinjaOne v2 API.
		.FUNCTIONALITY
			Knowledge Base Articles
		.EXAMPLE
			PS> Restore-NinjaOneKnowledgeBaseFolders -folderIds @(10,11)

			Restores the specified folders.
		.OUTPUTS
			Status code (204) on success.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Restore/kb-folders
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('rtnokbf')]
	[MetadataAttribute(
		'/v2/knowledgebase/folders/restore',
		'post'
	)]
	Param(
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Int[]]$folderIds
	)
	process {
		try {
			$Resource = 'v2/knowledgebase/folders/restore'
			$RequestParams = @{ Resource = $Resource; Body = $folderIds }
			if ($PSCmdlet.ShouldProcess('Knowledge Base Folders', 'Restore')) {
				$Response = New-NinjaOnePOSTRequest @RequestParams
				return $Response
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

