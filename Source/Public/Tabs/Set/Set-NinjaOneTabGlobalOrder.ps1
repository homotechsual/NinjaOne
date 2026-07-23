function Set-NinjaOneTabGlobalOrder {
	<#
		.SYNOPSIS
			Updates the order of custom tabs globally.
		.DESCRIPTION
			Updates the order of globally available custom tabs via the NinjaOne v2 API.
		.FUNCTIONALITY
			Tab Global Order
		.EXAMPLE
			PS> Set-NinjaOneTabGlobalOrder -order @(
				@{ tabId = 1; order = 1 },
				@{ tabId = 2; order = 2 }
			)

			Sets the global tabs order.
		.OUTPUTS
			Updated order data per API.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/tab-global-order
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snotabgo')]
	[MetadataAttribute(
		'/v2/tab/global/order',
		'patch'
	)]
	param(
		# Array payload specifying the tab ordering.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$order
	)
	process {
		try {
			$Resource = 'v2/tab/global/order'
			$RequestParams = @{ Resource = $Resource; Body = $order }
			if ($PSCmdlet.ShouldProcess('Global Tabs', 'Update Order')) {
				$Result = New-NinjaOnePATCHRequest @RequestParams
				return $Result
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
