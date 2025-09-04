function Set-NinjaOneTabEndUserOrder {
	<#
		.SYNOPSIS
			Updates the order of custom tabs for end-user tabs.
		.DESCRIPTION
			Updates the order of custom tabs for end-user tabs via the NinjaOne v2 API. NOTE: All tabs defined for end-users must be specified in the payload.
		.FUNCTIONALITY
			Tabs
		.EXAMPLE
			PS> Set-NinjaOneTabEndUserOrder -order @(
				@{ tabId = 1; order = 1 },
				@{ tabId = 2; order = 2 }
			)

			Sets the order of the end-user tabs.
		.OUTPUTS
			Status code or updated order data per API.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/tab-enduser-order
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snotabeuo')]
	[MetadataAttribute(
		'/v2/tab/end-user/order',
		'patch'
	)]
	Param(
		# Array payload specifying the tab order per API schema (CustomTabsOrderPublicApiDTO[])
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$order
	)
	process {
		try {
			$Resource = 'v2/tab/end-user/order'
			$RequestParams = @{ Resource = $Resource; Body = $order }
			if ($PSCmdlet.ShouldProcess('End-user Tabs', 'Update Order')) {
				$Result = New-NinjaOnePATCHRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

