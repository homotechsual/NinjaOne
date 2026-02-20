function Get-NinjaOneTabEndUser {
	<#
		.SYNOPSIS
			Gets the end-user for a tab.
		.DESCRIPTION
			Retrieves the end-user associated with a tab via the NinjaOne v2 API.
		.FUNCTIONALITY
			Tabs
		.EXAMPLE
			PS> Get-NinjaOneTabEndUser -tabId 5

			Gets the end-user for tab Id 5.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/tab-enduser
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnotabeu')]
	[MetadataAttribute(
		'/v2/tab/{tabId}/end-user',
		'get'
	)]
	Param(
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$tabId
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		if ($tabId) { $Parameters.Remove('tabId') | Out-Null }
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			$Resource = ('v2/tab/{0}/end-user' -f $tabId)
			$RequestParams = @{ Resource = $Resource; QSCollection = $QSCollection }
			$Result = New-NinjaOneGETRequest @RequestParams
			if ($Result) {
				return $Result
			} else {
				throw ('End-user for tab {0} not found.' -f $tabId)
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
