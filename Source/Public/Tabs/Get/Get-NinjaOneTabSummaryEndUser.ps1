function Get-NinjaOneTabSummaryEndUser {
	<#
		.SYNOPSIS
			Gets the summary of custom tabs available to end-user views.
		.DESCRIPTION
			Retrieves a summary of the custom tabs available to end-user views via the NinjaOne v2 API.
		.FUNCTIONALITY
			Tabs
		.EXAMPLE
			PS> Get-NinjaOneTabSummaryEndUser

			Gets the end-user custom tabs summary.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/tab-summary-enduser
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnotabse')]
	[MetadataAttribute(
		'/v2/tab/summary/end-user',
		'get'
	)]
	param()
	process {
		try {
			$Resource = 'v2/tab/summary/end-user'
			$RequestParams = @{ Resource = $Resource }
			$Result = New-NinjaOneGETRequest @RequestParams
			if ($Result) { return $Result } else { throw 'No end-user tab summary found.' }
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

