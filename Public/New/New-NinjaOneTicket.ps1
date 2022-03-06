
using namespace System.Management.Automation
#Requires -Version 7
function New-NinjaOneTicket {
    <#
        .SYNOPSIS
            Creates a new ticket using the NinjaOne API.
        .DESCRIPTION
            Create a ticket using the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # An object containing the ticket to create.
        [Parameter(Mandatory = $true)]
        [object]$ticket,
        # Show the organisation that was created.
        [switch]$show
    )
    try {
        $Resource = 'v2/ticketing/ticket'
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