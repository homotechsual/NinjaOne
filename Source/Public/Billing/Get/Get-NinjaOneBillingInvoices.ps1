function Get-NinjaOneBillingInvoices {
	<#
		.SYNOPSIS
			Gets billing invoices.
		.DESCRIPTION
			Retrieves billing invoices or a specific billing invoice from the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Invoices
		.EXAMPLE
			PS> Get-NinjaOneBillingInvoices

			Gets all billing invoices.
		.EXAMPLE
			PS> Get-NinjaOneBillingInvoices -Id 1

			Gets billing invoice 1.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/billinginvoices
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnobis')]
	[MetadataAttribute(
		'/v2/billing/invoices',
		'get',
		'/v2/billing/invoices/{id}',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# Billing invoice ID.
		[Parameter(ValueFromPipelineByPropertyName)]
		[Alias('invoiceId')]
		[Int]$Id
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		if ($PSBoundParameters.ContainsKey('Id')) {
			$Parameters.Remove('Id') | Out-Null
		}
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			if ($Id) {
				Write-Verbose ('Getting billing invoice with id {0}.' -f $Id)
				$Resource = ('v2/billing/invoices/{0}' -f $Id)
			} else {
				Write-Verbose 'Retrieving billing invoices.'
				$Resource = 'v2/billing/invoices'
			}

			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$Results = New-NinjaOneGETRequest @RequestParams
			if ($Results) {
				return $Results
			} else {
				throw 'No billing invoices found.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
