function Set-NinjaOneBillingAccount {
	<#
		.SYNOPSIS
			Updates a billing account.
		.DESCRIPTION
			Updates an existing billing account using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Account
		.EXAMPLE
			PS> Set-NinjaOneBillingAccount -id 1 -billingAccount @{ name = 'Updated Account' }

			Updates billing account 1.
		.OUTPUTS
			A PowerShell object containing the updated billing account.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/billingaccount
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snoba')]
	[MetadataAttribute(
		'/v2/billing/accounts/{id}',
		'put'
	)]
	param(
		# Billing account ID.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('accountId')]
		[Int]$id,
		# Billing account payload per API schema.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$billingAccount
	)
	process {
		try {
			$Resource = ('v2/billing/accounts/{0}' -f $id)
			$RequestParams = @{ Resource = $Resource; Body = $billingAccount }
			if ($PSCmdlet.ShouldProcess(('Billing Account {0}' -f $id), 'Update')) {
				return (New-NinjaOnePUTRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
