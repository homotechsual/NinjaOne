function New-NinjaOneBillingTicketProductAdHoc {
	<#
		.SYNOPSIS
			Creates an ad hoc billing ticket product.
		.DESCRIPTION
			Creates an ad hoc billing ticket product using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Ticket Product Ad Hoc
		.EXAMPLE
			PS> New-NinjaOneBillingTicketProductAdHoc -TicketProduct @{ ticketId = 1 }

			Creates an ad hoc billing ticket product.
		.OUTPUTS
			A PowerShell object containing the created ticket product.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/billingticketproduct-adhoc
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnobtpa')]
	[MetadataAttribute(
		'/v2/billing/ticket-products/adhoc',
		'post'
	)]
	param(
		# Ticket product payload per API schema.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$TicketProduct
	)
	process {
		try {
			$Resource = 'v2/billing/ticket-products/adhoc'
			$RequestParams = @{ Resource = $Resource; Body = $TicketProduct }
			if ($PSCmdlet.ShouldProcess('Billing Ticket Product', 'Create Ad Hoc')) {
				return (New-NinjaOnePOSTRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
