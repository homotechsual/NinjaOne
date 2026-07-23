function Get-NinjaOneTabSummaryGlobal {
	<#
		.SYNOPSIS
			Gets the summary of custom tabs available globally.
		.DESCRIPTION
			Retrieves a summary of all custom tabs available globally via the NinjaOne v2 API.
		.FUNCTIONALITY
			Tab Summary Global
		.EXAMPLE
			PS> Get-NinjaOneTabSummaryGlobal

			Gets the global custom tabs summary.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/tab-summary-global
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnotabsg')]
	[MetadataAttribute(
		'/v2/tab/summary/global',
		'get'
	)]
	param()
	process {
		try {
			$Resource = 'v2/tab/summary/global'
			$RequestParams = @{ Resource = $Resource }
			$Result = New-NinjaOneGETRequest @RequestParams
			if ($Result) {
				return $Result
			} else {
				throw 'No global tab summary found.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
