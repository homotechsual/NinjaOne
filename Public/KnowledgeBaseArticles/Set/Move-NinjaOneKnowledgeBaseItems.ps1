function Move-NinjaOneKnowledgeBaseItems {
	<#
		.SYNOPSIS
			Moves knowledge base folders and documents to another folder.
		.DESCRIPTION
			Moves knowledge base items using the NinjaOne v2 API.
		.FUNCTIONALITY
			Knowledge Base Articles
		.EXAMPLE
			PS> Move-NinjaOneKnowledgeBaseItems -moveRequest @{ sourceFolderIds=@(1); sourceDocumentIds=@(2,3); targetFolderId=10 }

			Moves the specified KB items to folder 10.
		.OUTPUTS
			Status code (204) on success.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/kb-move
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('mvnokbi')]
	[MetadataAttribute(
		'/v2/knowledgebase/folders/move',
		'patch'
	)]
	Param(
		# Move request payload per API schema (MovePublicApiRequest)
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$moveRequest
	)
	process {
		try {
			$Resource = 'v2/knowledgebase/folders/move'
			$RequestParams = @{ Resource = $Resource; Body = $moveRequest }
			if ($PSCmdlet.ShouldProcess('Knowledge Base Items', 'Move')) {
				$Response = New-NinjaOnePATCHRequest @RequestParams
				return $Response
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

