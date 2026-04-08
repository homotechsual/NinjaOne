function New-NinjaOneBillingAgreement {
	<#
		.SYNOPSIS
			Creates a billing agreement.
		.DESCRIPTION
			Creates a new billing agreement using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Agreement
		.EXAMPLE
			PS> New-NinjaOneBillingAgreement -BillingAgreement @{ name = 'Premium Support' }

			Creates a billing agreement.
		.OUTPUTS
			A PowerShell object containing the created billing agreement.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/billingagreement
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnobag')]
	[MetadataAttribute(
		'/v2/billing/agreements',
		'post'
	)]
	param(
		# Billing agreement payload per API schema.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$BillingAgreement
	)
	process {
		try {
			$Resource = 'v2/billing/agreements'
			$RequestParams = @{ Resource = $Resource; Body = $BillingAgreement }
			if ($PSCmdlet.ShouldProcess('Billing Agreement', 'Create')) {
				return (New-NinjaOnePOSTRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
