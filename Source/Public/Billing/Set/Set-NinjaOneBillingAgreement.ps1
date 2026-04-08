function Set-NinjaOneBillingAgreement {
	<#
		.SYNOPSIS
			Updates a billing agreement.
		.DESCRIPTION
			Updates an existing billing agreement using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Agreement
		.EXAMPLE
			PS> Set-NinjaOneBillingAgreement -Id 1 -BillingAgreement @{ name = 'Updated Agreement' }

			Updates billing agreement 1.
		.OUTPUTS
			A PowerShell object containing the updated billing agreement.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/billingagreement
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snobag')]
	[MetadataAttribute(
		'/v2/billing/agreements/{id}',
		'put'
	)]
	param(
		# Billing agreement ID.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('agreementId')]
		[Int]$Id,
		# Billing agreement payload per API schema.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$BillingAgreement
	)
	process {
		try {
			$Resource = ('v2/billing/agreements/{0}' -f $Id)
			$RequestParams = @{ Resource = $Resource; Body = $BillingAgreement }
			if ($PSCmdlet.ShouldProcess(('Billing Agreement {0}' -f $Id), 'Update')) {
				return (New-NinjaOnePUTRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
