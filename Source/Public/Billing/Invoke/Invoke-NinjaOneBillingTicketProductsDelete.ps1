function Invoke-NinjaOneBillingTicketProductsDelete {
	<#
		.SYNOPSIS
			Deletes billing ticket products.
		.DESCRIPTION
			Deletes one or more billing ticket products using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Ticket Products
		.EXAMPLE
			PS> Invoke-NinjaOneBillingTicketProductsDelete -request @{ ticketProductIds = @(1,2) }

			Deletes the specified billing ticket products.
		.OUTPUTS
			The API response indicating success or failure.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/billingticketproducts-delete
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
	[OutputType([Object])]
	[Alias('inobtpd')]
	[MetadataAttribute(
		'/v2/billing/ticket-products/delete',
		'post'
	)]
	param(
		# Delete request payload per API schema.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$request
	)
	process {
		try {
			$Resource = 'v2/billing/ticket-products/delete'
			$requestParams = @{ Resource = $Resource; Body = $request }
			if ($PSCmdlet.ShouldProcess('Billing Ticket Products', 'Delete')) {
				return (New-NinjaOnePOSTRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
