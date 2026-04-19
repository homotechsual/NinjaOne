function Set-NinjaOneTicket {
	<#
		.SYNOPSIS
			Sets a ticket.
		.DESCRIPTION
			Sets a ticket using the NinjaOne v2 API.
		.FUNCTIONALITY
			Ticket
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				subject = "string"
				priority = "NONE"
				severity = "NONE"
				followupTime = 0
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
				version = 0
				tags = @(
					"string"
				)
			}
			PS> Set-NinjaOneTicket -ticketId 1 -ticket $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/ticket
	
	.EXAMPLE
		PS> Set-NinjaOneTicket -Identity 123 -Property 'Value'

		Updates the specified resource.

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
		[Alias('body')]
		[Object]$ticket,
		# Parse date/time values in the response.
		[Switch]$parseDateTime
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
			if ($parseDateTime) {
				$RequestParams.ParseDateTime = $parseDateTime
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














