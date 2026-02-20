## WIP Untested Code

function New-NinjaOneTicketComment {
	<#
		.SYNOPSIS
			Creates a new ticket comment using the NinjaOne API.
		.DESCRIPTION
			Create a ticket comment using the NinjaOne v2 API.
		.FUNCTIONALITY
			Ticket Comment
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/ticketcomment
	
	.EXAMPLE
		PS> $newObject = @{ Name = 'Example' }
		PS> New-NinjaOneTicketComment @newObject

		Creates a new resource with the specified properties.

	#>
	[CmdletBinding( SupportsShouldProcess, ConfirmImpact = 'Medium' )]
	[OutputType([Object])]
	[Alias('nnotc')]
	[MetadataAttribute(
		'/v2/ticketing/ticket/{ticketId}/comment',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The ticket Id to use when creating the ticket comment.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$ticketId,
		# An object containing the ticket comment to create.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Object]$comment,
		# Show the ticket comment that was created.
		[Switch]$show
	)
	begin { }
	process {
		try {
			$Resource = ('v2/ticketing/ticket/{0}/comment' -f $ticketId)
			$RequestParams = @{
				Resource = $Resource
				Body = $ticket
			}
			if ($PSCmdlet.ShouldProcess(('Ticket comment on ticket {0}' -f $ticketId), 'Create')) {
				$TicketCreate = New-NinjaOnePOSTRequest @RequestParams
				if ($show) {
					return $TicketCreate
				} else {
					Write-Information ('Ticket comment on ticket {0} created.' -f $ticketId)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
