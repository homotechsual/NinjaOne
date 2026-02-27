function New-NinjaOneTicket {
	<#
		.SYNOPSIS
			Creates a new ticket using the NinjaOne API.
		.DESCRIPTION
			Create a ticket using the NinjaOne v2 API.
		.FUNCTIONALITY
			Ticket
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				parentTicketId = 0
				clientId = 0
				attributes = @(
					@{
						id = 0
						attributeId = 0
						value = "string"
					}
				)
				followupTime = 0
				requesterUid = "00000000-0000-0000-0000-000000000000"
				locationId = 0
				severity = "NONE"
				description = @{
					body = "string"
					htmlBody = "string"
					public = $false
					duplicateInIncidents = $false
					timeTracked = 0
				}
				type = "PROBLEM"
				assignedAppUserId = 0
				nodeId = 0
				cc = @{
					emails = @(
						"string"
					)
					uids = @(
						"00000000-0000-0000-0000-000000000000"
					)
				}
				additionalAssignedTechnicianIds = @(
					0
				)
				status = "string"
				priority = "NONE"
				subject = "string"
				ticketFormId = 0
				tags = @(
					"string"
				)
			}
			PS> New-NinjaOneTicket -ticket $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/ticket
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
		[Alias('body')]
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















