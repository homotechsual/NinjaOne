function Invoke-NinjaOneBillingInvoicesApprove {
	<#
		.SYNOPSIS
			Approves billing invoices.
		.DESCRIPTION
			Approves one or more billing invoices using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Invoices Approve
		.EXAMPLE
			PS> Invoke-NinjaOneBillingInvoicesApprove -Request @{ invoiceIds = @(1,2) }

			Approves the specified billing invoices.
		.OUTPUTS
			The API response indicating success or failure.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/billinginvoices-approve
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('inobiap')]
	[MetadataAttribute(
		'/v2/billing/invoices/approve',
		'post'
	)]
	param(
		# Approval request payload per API schema.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$Request
	)
	process {
		try {
			$Resource = 'v2/billing/invoices/approve'
			$RequestParams = @{ Resource = $Resource; Body = $Request }
			if ($PSCmdlet.ShouldProcess('Billing Invoices', 'Approve')) {
				return (New-NinjaOnePOSTRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
