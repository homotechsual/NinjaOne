## WIP Untested Code

function New-NinjaOneTicketComment {
    <#
        .SYNOPSIS
            Creates a new ticket comment using the NinjaOne API.
        .DESCRIPTION
            Create a ticket comment using the NinjaOne v2 API.
        .FUNCTIONALITY
            Create Ticket Comment
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The ticket ID to use when creating the comment.
        [Parameter(Mandatory)]
        [int]$ticketId,
        # An object containing the ticket to create.
        [Parameter(Mandatory)]
        [object]$comment,
        # Show the organisation that was created.
        [switch]$show
    )
    if ($Script:NRAPIConnectionInformation.AuthMode -eq 'Client Credentials') {
        throw ('This function is not available when using client_credentials authentication. If this is unexpected please report this to api@ninjarmm.com.')
        exit 1
    }
    try {
        $Resource = "v2/ticketing/ticket/$($ticketId)/comment"
        $RequestParams = @{
            Resource = $Resource
            Body = $ticket
        }
        if ($PSCmdlet.ShouldProcess("Ticket '$($ticket.summary)'", 'Create')) {
            $TicketCreate = New-NinjaOnePOSTRequest @RequestParams
            if ($show) {
                Return $TicketCreate
            } else {
                Write-Information "Ticket '$($ticket.summary)' created."
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}