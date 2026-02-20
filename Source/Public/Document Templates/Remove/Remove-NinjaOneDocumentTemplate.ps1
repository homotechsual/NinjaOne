function Remove-NinjaOneDocumentTemplate {
	<#
		.SYNOPSIS
			Removes a document template using the NinjaOne API.
		.DESCRIPTION
			Removes the specified document template NinjaOne v2 API.
		.FUNCTIONALITY
			Document Template
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/documenttemplate
	
	.EXAMPLE
		PS> Remove-NinjaOneDocumentTemplate -Identity 123

		Removes the specified resource.

	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('rnodt')]
	[MetadataAttribute(
		'/v2/document-templates/{documentTemplateId}',
		'delete'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The document template to delete.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$documentTemplateId
	)
	process {
		try {
			$Resource = ('v2/document-templates/{0}' -f $documentTemplateId)
			$RequestParams = @{
				Resource = $Resource
			}
			if ($PSCmdlet.ShouldProcess(('Document Template {0}' -f $documentTemplateId), 'Delete')) {
				$DocumentTemplateDelete = New-NinjaOneDELETERequest @RequestParams
				if ($DocumentTemplateDelete -eq 204) {
					Write-Information ('Document template {0} deleted successfully.' -f $documentTemplateId)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
