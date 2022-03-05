
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
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'ticket=' parameter by removing it from the set parameters.
    if ($ticket) {
        $Parameters.Remove('ticket') | Out-Null
    }
    # Workaround to prevent the query string processor from adding an 'show=' parameter by removing it from the set parameters.
    if ($show) {
        $Parameters.Remove('show') | Out-Null
    }
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = 'v2/ticketing/ticket'
        $RequestParams = @{
            Method = 'POST'
            Resource = $Resource
            QSCollection = $QSCollection
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