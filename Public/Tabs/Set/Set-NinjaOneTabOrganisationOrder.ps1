function Set-NinjaOneTabOrganisationOrder {
	<#
		.SYNOPSIS
			Updates the order of custom tabs for organizations and locations.
		.DESCRIPTION
			Updates the order of custom tabs for organization/location tabs via the NinjaOne v2 API. NOTE: All org tabs must be specified.
		.FUNCTIONALITY
			Tabs
		.EXAMPLE
			PS> Set-NinjaOneTabOrganisationOrder -order @(
				@{ tabId = 1; order = 1 },
				@{ tabId = 2; order = 2 }
			)

			Sets the organization tabs order.
		.OUTPUTS
			Updated order data per API.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/tab-organization-order
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snotaboo')]
	[MetadataAttribute(
		'/v2/tab/organization/order',
		'patch'
	)]
	Param(
		# Array payload specifying the tab ordering (CustomTabsOrderPublicApiDTO[])
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$order
	)
	process {
		try {
			$Resource = 'v2/tab/organization/order'
			$RequestParams = @{ Resource = $Resource; Body = $order }
			if ($PSCmdlet.ShouldProcess('Organization Tabs', 'Update Order')) {
				$Result = New-NinjaOnePATCHRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

