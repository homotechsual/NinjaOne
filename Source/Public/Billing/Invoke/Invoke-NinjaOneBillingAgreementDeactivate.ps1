function Invoke-NinjaOneBillingAgreementDeactivate {
	<#
		.SYNOPSIS
			Deactivates a billing agreement.
		.DESCRIPTION
			Deactivates a billing agreement using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Agreement
		.EXAMPLE
			PS> Invoke-NinjaOneBillingAgreementDeactivate -Id 1

			Deactivates billing agreement 1.
		.OUTPUTS
			The API response indicating success or failure.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/billingagreement-deactivate
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('inobagd')]
	[MetadataAttribute(
		'/v2/billing/agreements/{id}/deactivate',
		'patch'
	)]
	param(
		# Billing agreement ID.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('agreementId')]
		[Int]$Id
	)
	process {
		try {
			$Resource = ('v2/billing/agreements/{0}/deactivate' -f $Id)
			if ($PSCmdlet.ShouldProcess(('Billing Agreement {0}' -f $Id), 'Deactivate')) {
				return (New-NinjaOnePATCHRequest -Resource $Resource)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
