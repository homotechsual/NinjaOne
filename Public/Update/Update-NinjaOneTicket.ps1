
using namespace System.Management.Automation
#Requires -Version 7
function Update-NinjaOneTicket {
    <#
        .SYNOPSIS
            Updates a ticket.
        .DESCRIPTION
            Updates a ticket using the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The ticket Id.
        [Parameter(Mandatory = $true)]
        [int]$ticketId,
        # The ticket object.
        [Parameter(Mandatory = $true)]
        [Object]$ticket 
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding a 'ticketId=' parameter by removing it from the set parameters.
    if ($ticketId) {
        $Parameters.Remove('ticketId') | Out-Null
    }
    # Workaround to prevent the query string processor from adding a 'ticket=' parameter by removing it from the set parameters.
    if ($ticket) {
        $Parameters.Remove('ticket') | Out-Null
    }
    try {
        $Resource = "v2/ticketing/ticket/$ticketId"
        $RequestParams = @{
            Method = 'PUT'
            Resource = $Resource
            Body = $ticket
        }
        if ($PSCmdlet.ShouldProcess('Ticket', 'Update')) {
            $TicketUpdate = New-NinjaOnePUTRequest @RequestParams
            if ($TicketUpdate -eq 204) {
                Write-Information 'Ticket updated successfully.'
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}