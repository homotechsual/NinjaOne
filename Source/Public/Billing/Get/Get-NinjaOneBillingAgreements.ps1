function Get-NinjaOneBillingAgreements {
	<#
		.SYNOPSIS
			Gets billing agreements.
		.DESCRIPTION
			Retrieves billing agreements or a specific billing agreement from the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Agreements
		.EXAMPLE
			PS> Get-NinjaOneBillingAgreements

			Gets all billing agreements.
		.EXAMPLE
			PS> Get-NinjaOneBillingAgreements -Id 1

			Gets billing agreement 1.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/billingagreements
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnobags')]
	[MetadataAttribute(
		'/v2/billing/agreements',
		'get',
		'/v2/billing/agreements/{id}',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# Billing agreement ID.
		[Parameter(ValueFromPipelineByPropertyName)]
		[Alias('agreementId')]
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
				Write-Verbose ('Getting billing agreement with id {0}.' -f $Id)
				$Resource = ('v2/billing/agreements/{0}' -f $Id)
			} else {
				Write-Verbose 'Retrieving billing agreements.'
				$Resource = 'v2/billing/agreements'
			}

			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$Results = New-NinjaOneGETRequest @RequestParams
			if ($Results) {
				return $Results
			} else {
				throw 'No billing agreements found.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
