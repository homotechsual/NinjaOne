function Get-NinjaOneOrganisationChecklist {
	<#
		.SYNOPSIS
			Gets an organisation checklist by Id.
		.DESCRIPTION
			Retrieves an organisation checklist via the NinjaOne v2 API.
		.FUNCTIONALITY
			Organisation Checklists
		.EXAMPLE
			PS> Get-NinjaOneOrganisationChecklist -checklistId 22

			Gets organisation checklist with Id 22.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationchecklist
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnoocl1', 'Get-NinjaOneOrganizationChecklist')]
	[MetadataAttribute(
		'/v2/organization/checklist/{checklistId}',
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
			$Resource = ('v2/organization/checklist/{0}' -f $checklistId)
			$RequestParams = @{ Resource = $Resource; QSCollection = $QSCollection }
			$Result = New-NinjaOneGETRequest @RequestParams
			if ($Result) { return $Result } else { throw ('Checklist {0} not found.' -f $checklistId) }
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
