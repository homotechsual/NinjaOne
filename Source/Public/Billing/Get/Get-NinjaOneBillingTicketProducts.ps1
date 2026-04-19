function Get-NinjaOneBillingTicketProducts {
	<#
		.SYNOPSIS
			Gets billing ticket products.
		.DESCRIPTION
			Retrieves billing ticket products for a specific ticket from the NinjaOne v2 API.
		.FUNCTIONALITY
			Billing Ticket Products
		.EXAMPLE
			PS> Get-NinjaOneBillingTicketProducts -ticketId 1

			Gets ticket billing products for ticket 1.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/billingticketproducts
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnobtps')]
	[MetadataAttribute(
		'/v2/billing/ticket-products/ticket/{id}',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# Ticket ID.
		[Parameter(Mandatory, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$ticketId
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		if ($PSBoundParameters.ContainsKey('TicketId')) {
			$Parameters.Remove('TicketId') | Out-Null
		}
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			$Resource = ('v2/billing/ticket-products/ticket/{0}' -f $ticketId)
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$Results = New-NinjaOneGETRequest @RequestParams
			if ($Results) {
				return $Results
			} else {
				throw ('No billing ticket products found for ticket {0}.' -f $ticketId)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
