function Invoke-NinjaOneTempAttachmentUpload {
	<#
		.SYNOPSIS
			Uploads temporary attachments in NinjaOne.
		.DESCRIPTION
			Uploads temporary attachments using the NinjaOne v2 API.
		.FUNCTIONALITY
			Temporary Attachments
		.EXAMPLE
			PS> Invoke-NinjaOneTempAttachmentUpload -entityType TICKET -upload @{ files = @() }

			Uploads temporary attachments for the given entity type.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/temp-attachment-upload
	#>
	[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[MetadataAttribute(
		'/v2/attachments/temp/upload',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# Entity type for the attachments.
		[Parameter(Position = 0)]
		[ValidateSet('TICKET','NODE','DOCUMENT','RELATED_ITEM','CHECKLIST','AUTOMATION','LOCATION','ORGANIZATION','TRIGGER','TECHNICIAN','FILE_TRANSFER_AUTOMATION','END_USER','EMAIL_TEMPLATE','POLICY')]
		[String]$entityType,
		# Upload payload (multipart/form-data content).
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$upload
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		$Parameters.Remove('upload') | Out-Null
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			$Resource = 'v2/attachments/temp/upload'
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
				Body = $upload
			}
			if ($PSCmdlet.ShouldProcess('Temporary attachments', 'Upload')) {
				return (New-NinjaOnePOSTRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
