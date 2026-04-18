function Get-NinjaOneBillingAccounts {
	<#
		.SYNOPSIS
			Gets billing accounts.
		.DESCRIPTION
			Retrieves billing accounts or a specific billing account from the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Accounts
		.EXAMPLE
			PS> Get-NinjaOneBillingAccounts

			Gets all billing accounts.
		.EXAMPLE
			PS> Get-NinjaOneBillingAccounts -id 1

			Gets billing account 1.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/billingaccounts
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnobas')]
	[MetadataAttribute(
		'/v2/billing/accounts',
		'get',
		'/v2/billing/accounts/{id}',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# Billing account ID.
		[Parameter(ValueFromPipelineByPropertyName)]
		[Alias('accountId')]
		[Int]$id
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
			if ($id) {
				Write-Verbose ('Getting billing account with id {0}.' -f $id)
				$Resource = ('v2/billing/accounts/{0}' -f $id)
			} else {
				Write-Verbose 'Retrieving billing accounts.'
				$Resource = 'v2/billing/accounts'
			}

			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$Results = New-NinjaOneGETRequest @RequestParams
			if ($Results) {
				return $Results
			} else {
				throw 'No billing accounts found.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
