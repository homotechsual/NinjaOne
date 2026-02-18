function Get-NinjaOneTab {
	<#
		.SYNOPSIS
			Gets a tab by Id.
		.DESCRIPTION
			Retrieves a tab via the NinjaOne v2 API.
		.FUNCTIONALITY
			Tabs
		.EXAMPLE
			PS> Get-NinjaOneTab -tabId 5

			Gets tab with Id 5.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/tab
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnotab')]
	[MetadataAttribute(
		'/v2/tab/{tabId}',
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
			$Resource = ('v2/tab/{0}' -f $tabId)
			$RequestParams = @{ Resource = $Resource; QSCollection = $QSCollection }
			$Result = New-NinjaOneGETRequest @RequestParams
			if ($Result) { return $Result } else { throw ('Tab {0} not found.' -f $tabId) }
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
