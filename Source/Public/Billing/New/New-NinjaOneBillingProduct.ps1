function New-NinjaOneBillingProduct {
	<#
		.SYNOPSIS
			Creates a billing product.
		.DESCRIPTION
			Creates a new billing product using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Product
		.EXAMPLE
			PS> New-NinjaOneBillingProduct -billingProduct @{ name = 'Managed Endpoint' }

			Creates a billing product.
		.OUTPUTS
			A PowerShell object containing the created billing product.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/billingproduct
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnobp')]
	[MetadataAttribute(
		'/v2/billing/products',
		'post'
	)]
	param(
		# Billing product payload per API schema.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$billingProduct
	)
	process {
		try {
			$Resource = 'v2/billing/products'
			$RequestParams = @{ Resource = $Resource; Body = $billingProduct }
			if ($PSCmdlet.ShouldProcess('Billing Product', 'Create')) {
				return (New-NinjaOnePOSTRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
