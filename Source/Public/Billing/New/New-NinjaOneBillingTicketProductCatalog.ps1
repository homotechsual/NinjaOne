function New-NinjaOneBillingTicketProductCatalog {
	<#
		.SYNOPSIS
			Creates a catalog billing ticket product.
		.DESCRIPTION
			Creates a catalog billing ticket product using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Ticket Product Catalog
		.EXAMPLE
			PS> New-NinjaOneBillingTicketProductCatalog -ticketProduct @{ ticketId = 1 }

			Creates a catalog billing ticket product.
		.OUTPUTS
			A PowerShell object containing the created ticket product.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/billingticketproduct-catalog
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnobtpc')]
	[MetadataAttribute(
		'/v2/billing/ticket-products/catalog',
		'post'
	)]
	param(
		# Ticket product payload per API schema.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$ticketProduct
	)
	process {
		try {
			$Resource = 'v2/billing/ticket-products/catalog'
			$RequestParams = @{ Resource = $Resource; Body = $ticketProduct }
			if ($PSCmdlet.ShouldProcess('Billing Ticket Product', 'Create Catalog')) {
				return (New-NinjaOnePOSTRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
