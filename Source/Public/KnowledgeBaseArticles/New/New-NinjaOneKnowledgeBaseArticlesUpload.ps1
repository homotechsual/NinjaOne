function New-NinjaOneKnowledgeBaseArticlesUpload {
	<#
		.SYNOPSIS
			Uploads knowledge base articles.
		.DESCRIPTION
			Uploads one or more knowledge base articles via the NinjaOne v2 API.
		.FUNCTIONALITY
			Knowledge Base Articles
		.EXAMPLE
			PS> New-NinjaOneKnowledgeBaseArticlesUpload -OrganizationId 1 -FilePath 'C:\articles.zip'

			Uploads knowledge base articles from a file to the specified organization.
		.OUTPUTS
			A PowerShell object containing the created articles or job result.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/knowledgebase-articles-upload
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnokbau')]
	[MetadataAttribute(
		'/v2/knowledgebase/articles/upload',
		'post'
	)]
	param(
		# Organization ID
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Int]$OrganizationId,
		# Folder ID
		[Parameter(Position = 1, ValueFromPipelineByPropertyName)]
		[Int]$FolderId,
		# Folder Path
		[Parameter(Position = 2, ValueFromPipelineByPropertyName)]
		[String]$FolderPath,
		# File path(s) to upload
		[Parameter(Mandatory, Position = 3, ValueFromPipelineByPropertyName)]
		[String[]]$FilePath
	)
	process {
		try {
			$Resource = 'v2/knowledgebase/articles/upload'
			$Body = @{
				organizationId = $OrganizationId
			}
			if ($FolderId) {
				$Body.folderId = $FolderId
			}
			if ($FolderPath) {
				$Body.folderPath = $FolderPath
			}
			if ($FilePath) {
				$Body.files = $FilePath
			}
			$RequestParams = @{ Resource = $Resource; Body = $Body }
			if ($PSCmdlet.ShouldProcess('Knowledge Base Articles', 'Upload')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
