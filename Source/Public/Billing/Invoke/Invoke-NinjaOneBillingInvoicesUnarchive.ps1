function Invoke-NinjaOneBillingInvoicesUnarchive {
	<#
		.SYNOPSIS
			Unarchives billing invoices.
		.DESCRIPTION
			Unarchives one or more billing invoices using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Invoices
		.EXAMPLE
			PS> Invoke-NinjaOneBillingInvoicesUnarchive -Request @{ invoiceIds = @(1,2) }

			Unarchives the specified billing invoices.
		.OUTPUTS
			The API response indicating success or failure.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/billinginvoices-unarchive
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('inobiun')]
	[MetadataAttribute(
		'/v2/billing/invoices/unarchive',
		'post'
	)]
	param(
		# Unarchive request payload per API schema.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$Request
	)
	process {
		try {
			$Resource = 'v2/billing/invoices/unarchive'
			$RequestParams = @{ Resource = $Resource; Body = $Request }
			if ($PSCmdlet.ShouldProcess('Billing Invoices', 'Unarchive')) {
				return (New-NinjaOnePOSTRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
