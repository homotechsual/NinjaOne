function Set-NinjaOneBillingInvoiceNote {
	<#
		.SYNOPSIS
			Updates a billing invoice note.
		.DESCRIPTION
			Updates the note for a billing invoice using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Invoice Note
		.EXAMPLE
			PS> Set-NinjaOneBillingInvoiceNote -id 1 -note @{ note = 'Customer confirmed billing details' }

			Updates the note on billing invoice 1.
		.OUTPUTS
			The API response indicating success or failure.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/billinginvoicenote
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snobin')]
	[MetadataAttribute(
		'/v2/billing/invoices/{id}/note',
		'patch'
	)]
	param(
		# Billing invoice ID.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('invoiceId')]
		[Int]$id,
		# Billing invoice note payload per API schema.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$note
	)
	process {
		try {
			$Resource = ('v2/billing/invoices/{0}/note' -f $id)
			$RequestParams = @{ Resource = $Resource; Body = $note }
			if ($PSCmdlet.ShouldProcess(('Billing Invoice {0}' -f $id), 'Update Note')) {
				return (New-NinjaOnePATCHRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
