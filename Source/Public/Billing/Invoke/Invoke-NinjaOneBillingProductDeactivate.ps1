function Invoke-NinjaOneBillingProductDeactivate {
	<#
		.SYNOPSIS
			Deactivates a billing product.
		.DESCRIPTION
			Deactivates a billing product using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Product Deactivate
		.EXAMPLE
			PS> Invoke-NinjaOneBillingProductDeactivate -Id 1

			Deactivates billing product 1.
		.OUTPUTS
			The API response indicating success or failure.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/billingproduct-deactivate
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('inobpde')]
	[MetadataAttribute(
		'/v2/billing/products/{id}/deactivate',
		'patch'
	)]
	param(
		# Billing product ID.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('productId')]
		[Int]$Id
	)
	process {
		try {
			$Resource = ('v2/billing/products/{0}/deactivate' -f $Id)
			if ($PSCmdlet.ShouldProcess(('Billing Product {0}' -f $Id), 'Deactivate')) {
				return (New-NinjaOnePATCHRequest -Resource $Resource)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
