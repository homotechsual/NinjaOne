function Invoke-NinjaOneBillingInvoicesExport {
	<#
		.SYNOPSIS
			Exports billing invoices.
		.DESCRIPTION
			Exports one or more billing invoices using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Invoices Export
		.EXAMPLE
			PS> Invoke-NinjaOneBillingInvoicesExport -Request @{ invoiceIds = @(1,2) }

			Exports the specified billing invoices.
		.OUTPUTS
			The API response indicating success or failure.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/billinginvoices-export
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('inobiex')]
	[MetadataAttribute(
		'/v2/billing/invoices/export',
		'post'
	)]
	param(
		# Export request payload per API schema.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$Request
	)
	process {
		try {
			$Resource = 'v2/billing/invoices/export'
			$RequestParams = @{ Resource = $Resource; Body = $Request }
			if ($PSCmdlet.ShouldProcess('Billing Invoices', 'Export')) {
				return (New-NinjaOnePOSTRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
