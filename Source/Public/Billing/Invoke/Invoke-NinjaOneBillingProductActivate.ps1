function Invoke-NinjaOneBillingProductActivate {
	<#
		.SYNOPSIS
			Activates a billing product.
		.DESCRIPTION
			Activates a billing product using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Product
		.EXAMPLE
			PS> Invoke-NinjaOneBillingProductActivate -Id 1

			Activates billing product 1.
		.OUTPUTS
			The API response indicating success or failure.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/billingproduct-activate
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('inobpac')]
	[MetadataAttribute(
		'/v2/billing/products/{id}/activate',
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
			$Resource = ('v2/billing/products/{0}/activate' -f $Id)
			if ($PSCmdlet.ShouldProcess(('Billing Product {0}' -f $Id), 'Activate')) {
				return (New-NinjaOnePATCHRequest -Resource $Resource)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
