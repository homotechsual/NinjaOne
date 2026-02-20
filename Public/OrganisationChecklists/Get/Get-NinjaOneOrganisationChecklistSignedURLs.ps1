function Get-NinjaOneOrganisationChecklistSignedURLs {
	<#
		.SYNOPSIS
			Gets signed URLs for an organisation checklist.
		.DESCRIPTION
			Retrieves signed URLs for an organisation checklist via the NinjaOne v2 API.
		.FUNCTIONALITY
			Organisation Checklists
		.EXAMPLE
			PS> Get-NinjaOneOrganisationChecklistSignedURLs -checklistId 22

			Gets signed URLs for organisation checklist Id 22.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationchecklist-signedurls
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnooclsu', 'Get-NinjaOneOrganizationChecklistSignedURLs')]
	[MetadataAttribute(
		'/v2/organization/checklist/{checklistId}/signed-urls',
		'get'
	)]
	Param(
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$checklistId
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		if ($checklistId) { $Parameters.Remove('checklistId') | Out-Null }
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			$Resource = ('v2/organization/checklist/{0}/signed-urls' -f $checklistId)
			$RequestParams = @{ Resource = $Resource; QSCollection = $QSCollection }
			$Result = New-NinjaOneGETRequest @RequestParams
			if ($Result) {
				return $Result
			} else {
				throw ('No signed URLs found for checklist {0}.' -f $checklistId)
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
