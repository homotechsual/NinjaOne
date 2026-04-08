function New-NinjaOneBillingAccount {
	<#
		.SYNOPSIS
			Creates a billing account.
		.DESCRIPTION
			Creates a new billing account using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Account
		.EXAMPLE
			PS> New-NinjaOneBillingAccount -BillingAccount @{ name = 'Managed Services' }

			Creates a billing account.
		.OUTPUTS
			A PowerShell object containing the created billing account.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/billingaccount
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnoba')]
	[MetadataAttribute(
		'/v2/billing/accounts',
		'post'
	)]
	param(
		# Billing account payload per API schema.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$BillingAccount
	)
	process {
		try {
			$Resource = 'v2/billing/accounts'
			$RequestParams = @{ Resource = $Resource; Body = $BillingAccount }
			if ($PSCmdlet.ShouldProcess('Billing Account', 'Create')) {
				return (New-NinjaOnePOSTRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
