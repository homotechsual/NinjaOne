function New-NinjaOneBillingInvoice {
	<#
		.SYNOPSIS
			Creates a billing invoice.
		.DESCRIPTION
			Creates a new billing invoice using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Invoice
		.EXAMPLE
			PS> New-NinjaOneBillingInvoice -billingInvoice @{ invoiceNumber = 'INV-001' }

			Creates a billing invoice.
		.OUTPUTS
			A PowerShell object containing the created billing invoice.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/billinginvoice
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnobi')]
	[MetadataAttribute(
		'/v2/billing/invoices',
		'post'
	)]
	param(
		# Billing invoice payload per API schema.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$billingInvoice
	)
	process {
		try {
			$Resource = 'v2/billing/invoices'
			$RequestParams = @{ Resource = $Resource; Body = $billingInvoice }
			if ($PSCmdlet.ShouldProcess('Billing Invoice', 'Create')) {
				return (New-NinjaOnePOSTRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
