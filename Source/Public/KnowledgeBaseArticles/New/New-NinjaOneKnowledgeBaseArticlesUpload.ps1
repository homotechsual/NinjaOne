function New-NinjaOneKnowledgeBaseArticlesUpload {
	<#
		.SYNOPSIS
			Uploads knowledge base articles.
		.DESCRIPTION
			Uploads one or more knowledge base articles via the NinjaOne v2 API.
		.FUNCTIONALITY
		Knowledge Base Articles Upload
	.EXAMPLE
		PS> New-NinjaOneKnowledgeBaseArticlesUpload -OrganizationId 1 -FilePath 'C:\articles.zip'

		Uploads knowledge base articles from a file to the specified organization.
	.EXAMPLE
			PS> $organizationId = 0
			PS> $json = $organizationId | ConvertTo-Json -Depth 10
			PS> $stringContent = [System.Net.Http.StringContent]::new($json, [System.Text.Encoding]::UTF8, "application/json")
			PS> $multipart.Add($stringContent, "organizationId")
			PS> $folderId = 0
			PS> $json = $folderId | ConvertTo-Json -Depth 10
			PS> $stringContent = [System.Net.Http.StringContent]::new($json, [System.Text.Encoding]::UTF8, "application/json")
			PS> $multipart.Add($stringContent, "folderId")
			PS> $folderPath = "string"
			PS> $json = $folderPath | ConvertTo-Json -Depth 10
			PS> $stringContent = [System.Net.Http.StringContent]::new($json, [System.Text.Encoding]::UTF8, "application/json")
			PS> $multipart.Add($stringContent, "folderPath")
			PS> $filePath = "C:\Temp\example.txt"
			PS> $fileStream = [System.IO.FileStream]::new($filePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
			PS> $fileContent = [System.Net.Http.StreamContent]::new($fileStream)
			PS> $fileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse("application/octet-stream")
			PS> $multipart.Add($fileContent, "files", [System.IO.Path]::GetFileName($filePath))
			PS> $body = $multipart
			PS> New-NinjaOneKnowledgeBaseArticlesUpload -OrganizationId $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $multipart = [System.Net.Http.MultipartFormDataContent]::new()
			PS> $folderPath = "
			PS> $json = $folderPath | ConvertTo-Json -Depth 10
			PS> $stringContent = [System.Net.Http.StringContent]::new($json, [System.Text.Encoding]::UTF8, "application/json")
			PS> $multipart.Add($stringContent, "folderPath")
			PS> $filePath = "C:\Temp\example.txt"
			PS> $fileStream = [System.IO.FileStream]::new($filePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
			PS> $fileContent = [System.Net.Http.StreamContent]::new($fileStream)
			PS> $fileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse("application/octet-stream")
			PS> $multipart.Add($fileContent, "files", [System.IO.Path]::GetFileName($filePath))
			PS> $json = $folderId | ConvertTo-Json -Depth 10
			PS> $stringContent = [System.Net.Http.StringContent]::new($json, [System.Text.Encoding]::UTF8, "application/json")
			PS> $multipart.Add($stringContent, "folderId")
			PS> $json = $organizationId | ConvertTo-Json -Depth 10
			PS> $stringContent = [System.Net.Http.StringContent]::new($json, [System.Text.Encoding]::UTF8, "application/json")
			PS> $multipart.Add($stringContent, "organizationId")
			PS> $body = $multipart
			PS> New-NinjaOneKnowledgeBaseArticlesUpload -OrganizationId $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
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
			$RequestParams = @{ Resource = $Resource; Body = $Body; UseMultipart = $true }
			if ($PSCmdlet.ShouldProcess('Knowledge Base Articles', 'Upload')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}



