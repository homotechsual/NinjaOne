function Remove-NinjaOneBillingAccount {
	<#
		.SYNOPSIS
			Deletes a billing account.
		.DESCRIPTION
			Deletes a billing account using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Account
		.EXAMPLE
			PS> Remove-NinjaOneBillingAccount -Id 1

			Deletes billing account 1.
		.OUTPUTS
			The API response indicating success or failure.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/billingaccount
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
	[OutputType([Object])]
	[Alias('rnoba')]
	[MetadataAttribute(
		'/v2/billing/accounts/{id}',
		'delete'
	)]
	param(
		# Billing account ID.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('accountId')]
		[Int]$Id
	)
	process {
		try {
			$Resource = ('v2/billing/accounts/{0}' -f $Id)
			if ($PSCmdlet.ShouldProcess(('Billing Account {0}' -f $Id), 'Delete')) {
				return (New-NinjaOneDELETERequest -Resource $Resource)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
