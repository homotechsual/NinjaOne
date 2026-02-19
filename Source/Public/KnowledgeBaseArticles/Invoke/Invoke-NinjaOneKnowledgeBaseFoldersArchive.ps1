function Invoke-NinjaOneKnowledgeBaseFoldersArchive {
	<#
		.SYNOPSIS
			Archives knowledge base folders.
		.DESCRIPTION
			Archives knowledge base folders via the NinjaOne v2 API.
		.FUNCTIONALITY
			Knowledge Base Articles
		.EXAMPLE
			PS> Invoke-NinjaOneKnowledgeBaseFoldersArchive -folderIds @(10,11)

			Archives the specified folders.
		.OUTPUTS
			Status code (204) on success.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/kb-folders-archive
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('inokbfa')]
	[MetadataAttribute(
		'/v2/knowledgebase/folders/archive',
		'post'
	)]
	param(
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Int[]]$folderIds
	)
	process {
		try {
			$Resource = 'v2/knowledgebase/folders/archive'
			$RequestParams = @{ Resource = $Resource; Body = $folderIds }
			if ($PSCmdlet.ShouldProcess('Knowledge Base Folders', 'Archive')) {
				$Response = New-NinjaOnePOSTRequest @RequestParams
				return $Response
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

