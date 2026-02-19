function Remove-NinjaOneOrganisationChecklist {
	<#
		.SYNOPSIS
			Removes an organisation checklist.
		.DESCRIPTION
			Deletes an organisation checklist via the NinjaOne v2 API.
		.FUNCTIONALITY
			Organisation Checklists
		.EXAMPLE
			PS> Remove-NinjaOneOrganisationChecklist -checklistId 22 -Confirm:$false

			Deletes checklist 22.
		.OUTPUTS
			Status code (204) on success.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/organisationchecklist
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('rnoocl')]
	[MetadataAttribute(
		'/v2/organization/checklist/{checklistId}',
		'delete'
	)]
	param(
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$checklistId
	)
	process {
		try {
			$Resource = ('v2/organization/checklist/{0}' -f $checklistId)
			$RequestParams = @{ Resource = $Resource }
			if ($PSCmdlet.ShouldProcess(('Checklist {0}' -f $checklistId), 'Delete')) {
				$Response = New-NinjaOneDELETERequest @RequestParams
				if ($Response -eq 204) { Write-Information ('Checklist {0} deleted successfully.' -f $checklistId) }
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

