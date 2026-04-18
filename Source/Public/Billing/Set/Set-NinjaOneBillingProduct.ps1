function Set-NinjaOneBillingProduct {
	<#
		.SYNOPSIS
			Updates a billing product.
		.DESCRIPTION
			Updates an existing billing product using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Product
		.EXAMPLE
			PS> Set-NinjaOneBillingProduct -id 1 -billingProduct @{ name = 'Updated Product' }

			Updates billing product 1.
		.OUTPUTS
			A PowerShell object containing the updated billing product.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/billingproduct
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snobp')]
	[MetadataAttribute(
		'/v2/billing/products/{id}',
		'put'
	)]
	param(
		# Billing product ID.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('productId')]
		[Int]$id,
		# Billing product payload per API schema.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$billingProduct
	)
	process {
		try {
			$Resource = ('v2/billing/products/{0}' -f $id)
			$RequestParams = @{ Resource = $Resource; Body = $billingProduct }
			if ($PSCmdlet.ShouldProcess(('Billing Product {0}' -f $id), 'Update')) {
				return (New-NinjaOnePUTRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
