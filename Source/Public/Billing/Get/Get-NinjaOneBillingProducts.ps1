function Get-NinjaOneBillingProducts {
	<#
		.SYNOPSIS
			Gets billing products.
		.DESCRIPTION
			Retrieves billing products or a specific billing product from the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Products
		.EXAMPLE
			PS> Get-NinjaOneBillingProducts

			Gets all billing products.
		.EXAMPLE
			PS> Get-NinjaOneBillingProducts -Id 1

			Gets billing product 1.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/billingproducts
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnobps')]
	[MetadataAttribute(
		'/v2/billing/products',
		'get',
		'/v2/billing/products/{id}',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# Billing product ID.
		[Parameter(ValueFromPipelineByPropertyName)]
		[Alias('productId')]
		[Int]$Id
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			if ($Id) {
				Write-Verbose ('Getting billing product with id {0}.' -f $Id)
				$Resource = ('v2/billing/products/{0}' -f $Id)
			} else {
				Write-Verbose 'Retrieving billing products.'
				$Resource = 'v2/billing/products'
			}

			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$Results = New-NinjaOneGETRequest @RequestParams
			if ($Results) {
				return $Results
			} else {
				throw 'No billing products found.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
