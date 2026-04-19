function Set-NinjaOneBillingInvoice {
	<#
		.SYNOPSIS
			Updates a billing invoice.
		.DESCRIPTION
			Updates an existing billing invoice using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Invoice
		.EXAMPLE
			PS> Set-NinjaOneBillingInvoice -id 1 -billingInvoice @{ note = 'Updated invoice' }

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
		[Int]$id,
		# Billing invoice payload per API schema.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$billingInvoice
	)
	process {
		try {
			$Resource = ('v2/billing/invoices/{0}' -f $id)
			$RequestParams = @{ Resource = $Resource; Body = $billingInvoice }
			if ($PSCmdlet.ShouldProcess(('Billing Invoice {0}' -f $id), 'Update')) {
				return (New-NinjaOnePUTRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
