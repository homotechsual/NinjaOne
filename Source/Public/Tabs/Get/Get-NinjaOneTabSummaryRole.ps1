function Get-NinjaOneTabSummaryRole {
	<#
		.SYNOPSIS
			Gets the summary of custom tabs for a specified role.
		.DESCRIPTION
			Retrieves a summary of the custom tabs and extensions as viewed by the specified role via the NinjaOne v2 API.
		.FUNCTIONALITY
			Tabs
		.EXAMPLE
			PS> Get-NinjaOneTabSummaryRole -roleId 10

			Gets the custom tabs summary for role Id 10.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/tab-summary-role
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnotabsr')]
	[MetadataAttribute(
		'/v2/tab/summary/role/{roleId}',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# Role Id to retrieve tab summary for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Int]$roleId
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		if ($roleId) { $Parameters.Remove('roleId') | Out-Null }
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			$Resource = ('v2/tab/summary/role/{0}' -f $roleId)
			$RequestParams = @{ Resource = $Resource; QSCollection = $QSCollection }
			$Result = New-NinjaOneGETRequest @RequestParams
			if ($Result) { return $Result } else { throw ('No tab summary found for role {0}.' -f $roleId) }
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

