## WIP Untested Code

function New-NinjaOneTicketComment {
	<#
		.SYNOPSIS
			Creates a new ticket comment using the NinjaOne API.
		.DESCRIPTION
			Create a ticket comment using the NinjaOne v2 API.
		.FUNCTIONALITY
			Ticket Comment
		.EXAMPLE
			PS> New-NinjaOneTicketComment -ticketId 1 -comment @{ body = "Example"; public = $true }

			Creates a ticket comment on the specified ticket.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $multipart = [System.Net.Http.MultipartFormDataContent]::new()
			PS> $comment = @{
				public = $false
				body = "string"
				htmlBody = "string"
				timeTracked = 0
				duplicateInIncidents = $false
			}
			PS> $json = $comment | ConvertTo-Json -Depth 10
			PS> $stringContent = [System.Net.Http.StringContent]::new($json, [System.Text.Encoding]::UTF8, "application/json")
			PS> $multipart.Add($stringContent, "comment")
			PS> $filePath = "C:\Temp\example.txt"
			PS> $fileStream = [System.IO.FileStream]::new($filePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
			PS> $fileContent = [System.Net.Http.StreamContent]::new($fileStream)
			PS> $fileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse("application/octet-stream")
			PS> $multipart.Add($fileContent, "files", [System.IO.Path]::GetFileName($filePath))
			PS> $body = $multipart
			PS> New-NinjaOneTicketComment -ticketId 1 -comment $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/ticketcomment
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
		[Alias('body')]
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
				Body = $comment
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


