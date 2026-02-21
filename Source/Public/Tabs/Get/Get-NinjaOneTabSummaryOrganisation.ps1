function Get-NinjaOneTabSummaryOrganisation {
	<#
		.SYNOPSIS
			Gets the summary of custom tabs available to organisation views.
		.DESCRIPTION
			Retrieves a summary of the custom tabs available to organisation views via the NinjaOne v2 API.
		.FUNCTIONALITY
			Tabs
		.EXAMPLE
			PS> Get-NinjaOneTabSummaryOrganisation

			Gets the organisation custom tabs summary.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/tab-summary-organisation
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnotabso','Get-NinjaOneTabSummaryOrganization')]
	[MetadataAttribute(
		'/v2/tab/summary/organization',
		'get'
	)]
	param()
	process {
		try {
			$Resource = 'v2/tab/summary/organization'
			$RequestParams = @{ Resource = $Resource }
			$Result = New-NinjaOneGETRequest @RequestParams
			if ($Result) { return $Result } else { throw 'No organisation tab summary found.' }
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

