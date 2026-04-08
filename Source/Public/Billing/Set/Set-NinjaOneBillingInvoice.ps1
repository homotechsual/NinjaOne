function Set-NinjaOneBillingInvoice {
	<#
		.SYNOPSIS
			Updates a billing invoice.
		.DESCRIPTION
			Updates an existing billing invoice using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Invoice
		.EXAMPLE
			PS> Set-NinjaOneBillingInvoice -Id 1 -BillingInvoice @{ note = 'Updated invoice' }

			Updates billing invoice 1.
		.OUTPUTS
			A PowerShell object containing the updated billing invoice.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/billinginvoice
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snobi')]
	[MetadataAttribute(
		'/v2/billing/invoices/{id}',
		'put'
	)]
	param(
		# Billing invoice ID.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('invoiceId')]
		[Int]$Id,
		# Billing invoice payload per API schema.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$BillingInvoice
	)
	process {
		try {
			$Resource = ('v2/billing/invoices/{0}' -f $Id)
			$RequestParams = @{ Resource = $Resource; Body = $BillingInvoice }
			if ($PSCmdlet.ShouldProcess(('Billing Invoice {0}' -f $Id), 'Update')) {
				return (New-NinjaOnePUTRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
