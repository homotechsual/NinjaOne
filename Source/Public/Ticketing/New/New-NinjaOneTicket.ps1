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
				subject = "string"
				priority = "NONE"
				severity = "NONE"
				description = @{
					body = "string"
					public = $false
					timeTracked = 0
					htmlBody = "string"
					duplicateInIncidents = $false
				}
				parentTicketId = 0
				additionalAssignedTechnicianIds = @(
					0
				)
				type = "PROBLEM"
				locationId = 0
				status = "string"
				clientId = 0
				ticketFormId = 0
				nodeId = 0
				followupTime = 0
				requesterUid = "00000000-0000-0000-0000-000000000000"
				attributes = @(
					@{
						attributeId = 0
						id = 0
						value = "string"
					}
				)
				assignedAppUserId = 0
				cc = @{
					emails = @(
						"string"
					)
					uids = @(
						"00000000-0000-0000-0000-000000000000"
					)
				}
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




















