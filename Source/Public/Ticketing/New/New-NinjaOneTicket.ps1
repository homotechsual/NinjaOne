function New-NinjaOneTicket {
	<#
		.SYNOPSIS
			Creates a new ticket using the NinjaOne API.
		.DESCRIPTION
			Create a ticket using the NinjaOne v2 API.
		.FUNCTIONALITY
			Ticket
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/ticket
	
	.EXAMPLE
		PS> $newObject = @{ Name = 'Example' }
		PS> New-NinjaOneTicket @newObject

		Creates a new resource with the specified properties.

	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnot')]
	[MetadataAttribute(
		'/v2/ticketing/ticket',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# An object containing the ticket to create.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Object]$ticket,
		# Show the ticket that was created.
		[Switch]$show,
		# Parse date/time values in the response.
		[Switch]$ParseDateTime
	)
	begin { }
	process {
		try {
			$Resource = 'v2/ticketing/ticket'
			$RequestParams = @{
				Resource = $Resource
				Body = $ticket
			}
			if ($ParseDateTime) {
				$RequestParams.ParseDateTime = $ParseDateTime
			}
			if ($PSCmdlet.ShouldProcess(('Ticket {0}' -f $ticket.Subject), 'Create')) {
				$TicketCreate = New-NinjaOnePOSTRequest @RequestParams
				if ($show) {
					return $TicketCreate
				} else {
					Write-Information ('Ticket {0} created.' -f $TicketCreate.Subject)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
