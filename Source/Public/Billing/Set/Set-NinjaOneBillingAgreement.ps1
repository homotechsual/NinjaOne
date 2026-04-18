function Set-NinjaOneBillingAgreement {
	<#
		.SYNOPSIS
			Updates a billing agreement.
		.DESCRIPTION
			Updates an existing billing agreement using the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Agreement
		.EXAMPLE
			PS> Set-NinjaOneBillingAgreement -id 1 -billingAgreement @{ name = 'Updated Agreement' }

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
		[Int]$id,
		# Billing agreement payload per API schema.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$billingAgreement
	)
	process {
		try {
			$Resource = ('v2/billing/agreements/{0}' -f $id)
			$RequestParams = @{ Resource = $Resource; Body = $billingAgreement }
			if ($PSCmdlet.ShouldProcess(('Billing Agreement {0}' -f $id), 'Update')) {
				return (New-NinjaOnePUTRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
