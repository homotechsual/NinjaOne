
function Get-NinjaOneKnowledgeBaseFolders {
	<#
		.SYNOPSIS
			Gets knowledge base folders from the NinjaOne API.
		.DESCRIPTION
			Retrieves knowledge base folders and information on their contents from the NinjaOne v2 API.
		.FUNCTIONALITY
			Knowledge Base Folders
		.EXAMPLE
			PS> Get-NinjaOneKnowledgeBaseFolders

			Gets all knowledge base folders.
		.EXAMPLE
			PS> Get-NinjaOneKnowledgeBaseFolders -folderId 1

			Gets the knowledge base folder with id 1.
		.EXAMPLE
			PS> Get-NinjaOneKnowledgeBaseFolders -folderPath 'Folder/Subfolder'

			Gets the knowledge base folder with the path 'Folder/Subfolder'.
		.EXAMPLE
			PS> Get-NinjaOneKnowledgeBaseFolders -organisationId 1

			Gets all knowledge base folders for the organisation with id 1.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/knowledgebasefolders
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnokbf', 'Get-NinjaOneKnowledgeBaseFolder')]
	[MetadataAttribute(
		'/v2/knowledgebase/folder/{folderId}',
		'get',
		'/v2/knowledgebase/folder',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The knowledge base folder id to get.
		[Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$folderId,
		# The knowledge base folder path to get.
		[Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[String]$folderPath,
		# The organisation id to get knowledge base folders for.
		[Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Int]$organisationId
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		# Workaround to prevent the query string processor from adding an 'folderId=' parameter by removing it from the set parameters.
		$Parameters.Remove('folderId') | Out-Null
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			if ($folderId) {
				Write-Verbose ('Getting knowledge base folder with id {0}.' -f $folderId)
				$Resource = ('v2/knowledgebase/folder/{0}' -f $folderId)
			} else {
				Write-Verbose 'Getting knowledge base folders.'
				$Resource = 'v2/knowledgebase/folder'
			}
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$KnowledgeBaseFoldersResults = New-NinjaOneGETRequest @RequestParams
			return $KnowledgeBaseFoldersResults
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
