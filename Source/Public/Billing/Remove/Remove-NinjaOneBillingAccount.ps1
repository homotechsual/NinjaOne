function Remove-NinjaOneBillingAccount {
	<#
		.SYNOPSIS
			Deletes a billing account.
		.DESCRIPTION
			Deletes a billing account using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Account
		.EXAMPLE
			PS> Remove-NinjaOneBillingAccount -id 1

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
		[Int]$id
	)
	process {
		try {
			$Resource = ('v2/billing/accounts/{0}' -f $id)
			if ($PSCmdlet.ShouldProcess(('Billing Account {0}' -f $id), 'Delete')) {
				return (New-NinjaOneDELETERequest -Resource $Resource)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
