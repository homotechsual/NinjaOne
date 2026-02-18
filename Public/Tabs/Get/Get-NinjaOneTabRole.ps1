function Get-NinjaOneTabRole {
	<#
		.SYNOPSIS
			Gets a tab and extensions for a specific role.
		.DESCRIPTION
			Retrieves the requested tab along with any extensions based on the supplied role Id via the NinjaOne v2 API.
		.FUNCTIONALITY
			Tabs
		.EXAMPLE
			PS> Get-NinjaOneTabRole -tabId 5 -roleId 10

			Gets tab 5 with extensions as viewed by role 10.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/tab-role
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnotabr')]
	[MetadataAttribute(
		'/v2/tab/{tabId}/role/{roleId}',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Int]$tabId,
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Int]$roleId
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		if ($tabId) { $Parameters.Remove('tabId') | Out-Null }
		if ($roleId) { $Parameters.Remove('roleId') | Out-Null }
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			$Resource = ('v2/tab/{0}/role/{1}' -f $tabId, $roleId)
			$RequestParams = @{ Resource = $Resource; QSCollection = $QSCollection }
			$Result = New-NinjaOneGETRequest @RequestParams
			if ($Result) { return $Result } else { throw ('Tab {0} for role {1} not found.' -f $tabId, $roleId) }
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

