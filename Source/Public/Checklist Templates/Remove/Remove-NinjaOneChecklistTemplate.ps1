function Remove-NinjaOneChecklistTemplate {
	<#
		.SYNOPSIS
			Removes a checklist template.
		.DESCRIPTION
			Deletes a checklist template via the NinjaOne v2 API.
		.FUNCTIONALITY
			Checklist Templates
		.OUTPUTS
			Status code (204) on success.
		.EXAMPLE
			PS> Remove-NinjaOneChecklistTemplate -checklistTemplateId 10 -Confirm:$false

			Deletes the checklist template with Id 10.
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('rnoclt')]
	[MetadataAttribute(
		'/v2/checklist/template/{checklistTemplateId}',
		'delete'
	)]
	param(
		# Checklist template Id to delete.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$checklistTemplateId
	)
	process {
		try {
			$Resource = ('v2/checklist/template/{0}' -f $checklistTemplateId)
			$RequestParams = @{ Resource = $Resource }
			if ($PSCmdlet.ShouldProcess(('Checklist Template {0}' -f $checklistTemplateId), 'Delete')) {
				$Response = New-NinjaOneDELETERequest @RequestParams
				if ($Response -eq 204) { Write-Information ('Checklist template {0} deleted successfully.' -f $checklistTemplateId) }
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
