function Set-NinjaOneTicket {
	<#
		.SYNOPSIS
			Sets a ticket.
		.DESCRIPTION
			Sets a ticket using the NinjaOne v2 API.
		.FUNCTIONALITY
			Ticket
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/ticket
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snot', 'unot', 'Update-NinjaOneTicket')]
	[MetadataAttribute(
		'/v2/ticketing/ticket/{ticketId}',
		'put'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The ticket Id.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$ticketId,
		# The ticket object.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Object]$ticket
	)
	begin { }
	process {
		try {
			Write-Verbose ('Updating ticket {0}.' -f $ticketId)
			$Resource = "v2/ticketing/ticket/$ticketId"
			$RequestParams = @{
				Resource = $Resource
				Body = $ticket
			}
			if ($PSCmdlet.ShouldProcess(('Ticket {0}' -f $ticketId), 'Update')) {
				$TicketUpdate = New-NinjaOnePUTRequest @RequestParams
				if ($TicketUpdate -eq 204) {
					Write-Information ('Ticket {0} updated successfully.' -f $ticketId)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
