function Get-NinjaOneTicketStatuses {
	<#
		.SYNOPSIS
			Gets ticket statuses from the NinjaOne API.
		.DESCRIPTION
			Retrieves a list of ticket statuses from the NinjaOne v2 API.
		.FUNCTIONALITY
			Ticket Statuses
		.EXAMPLE
			PS> Get-NinjaOneTicketStatuses

			Gets the ticket statuses.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/ticketstatuses
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnots')]
	[MetadataAttribute(
		'/v2/ticketing/statuses',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param()
	process {
		try {
			Write-Verbose 'Retrieving ticket statuses from NinjaOne API.'
			$Resource = 'v2/ticketing/statuses'
			$RequestParams = @{
				Resource = $Resource
			}
			$TicketStatuses = New-NinjaOneGETRequest @RequestParams
			if ($TicketStatuses) {
				return $TicketStatuses
			} else {
				throw 'No ticket statuses found.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}