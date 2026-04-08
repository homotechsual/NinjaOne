function Set-NinjaOneBillingTicketProduct {
	<#
		.SYNOPSIS
			Updates a billing ticket product.
		.DESCRIPTION
			Updates a billing ticket product using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Ticket Product
		.EXAMPLE
			PS> Set-NinjaOneBillingTicketProduct -TicketProductId 1 -TicketProduct @{ quantity = 2 }

			Updates ticket product 1.
		.OUTPUTS
			A PowerShell object containing the updated ticket product.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/billingticketproduct
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snobtp')]
	[MetadataAttribute(
		'/v2/billing/ticket-products/{ticketProductId}',
		'put'
	)]
	param(
		# Ticket product ID.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$TicketProductId,
		# Ticket product payload per API schema.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$TicketProduct
	)
	process {
		try {
			$Resource = ('v2/billing/ticket-products/{0}' -f $TicketProductId)
			$RequestParams = @{ Resource = $Resource; Body = $TicketProduct }
			if ($PSCmdlet.ShouldProcess(('Billing Ticket Product {0}' -f $TicketProductId), 'Update')) {
				return (New-NinjaOnePUTRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
