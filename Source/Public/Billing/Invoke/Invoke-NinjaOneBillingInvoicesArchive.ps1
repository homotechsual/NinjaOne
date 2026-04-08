function Invoke-NinjaOneBillingInvoicesArchive {
	<#
		.SYNOPSIS
			Archives billing invoices.
		.DESCRIPTION
			Archives one or more billing invoices using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Invoices
		.EXAMPLE
			PS> Invoke-NinjaOneBillingInvoicesArchive -Request @{ invoiceIds = @(1,2) }

			Archives the specified billing invoices.
		.OUTPUTS
			The API response indicating success or failure.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/billinginvoices-archive
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('inobiar')]
	[MetadataAttribute(
		'/v2/billing/invoices/archive',
		'post'
	)]
	param(
		# Archive request payload per API schema.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$Request
	)
	process {
		try {
			$Resource = 'v2/billing/invoices/archive'
			$RequestParams = @{ Resource = $Resource; Body = $Request }
			if ($PSCmdlet.ShouldProcess('Billing Invoices', 'Archive')) {
				return (New-NinjaOnePOSTRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
