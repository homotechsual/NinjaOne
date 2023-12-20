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
    #>
    [CmdletBinding( SupportsShouldProcess, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Alias('nnotc')]
    [MetadataAttribute(
        '/v2/ticketing/ticket/{ticketId}/comment',
        'post'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
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
    begin {
        if ($Script:NRAPIConnectionInformation.AuthMode -eq 'Client Credentials') {
            throw ('This function is not available when using client_credentials authentication. If this is unexpected please report this to api@ninjarmm.com.')
            exit 1
        }
    }
    process {
        try {
            $Ticket = Get-NinjaOneTicket -ticketId $ticketId
            if ($Ticket) {
                $Resource = ('v2/ticketing/ticket/{0}/comment' -f $ticketId)
            } else {
                throw ('Ticket with id {0} not found.' -f $ticketId)
            }
            $RequestParams = @{
                Resource = $Resource
                Body = $ticket
            }
            if ($PSCmdlet.ShouldProcess(('Ticket comment on ticket {0} ({1})' -f $Ticket.id, $Ticket.summary), 'Create')) {
                $TicketCreate = New-NinjaOnePOSTRequest @RequestParams
                if ($show) {
                    return $TicketCreate
                } else {
                    $OIP = $InformationPreference
                    $InformationPreference = 'Continue'
                    Write-Information ('Ticket comment on ticket {0} ({1}) created.' -f $Ticket.id, $Ticket.summary)
                    $InformationPreference = $OIP
                }
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}