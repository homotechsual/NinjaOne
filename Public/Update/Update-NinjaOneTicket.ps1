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
    try {
        $Resource = "v2/ticketing/ticket/$ticketId"
        $RequestParams = @{
            Resource = $Resource
            Body = $ticket
        }
        $TicketExists = (Get-NinjaOneTicket -TicketId $ticketId).Count -gt 0
        if ($TicketExists) {
            if ($PSCmdlet.ShouldProcess('Ticket', 'Update')) {
                $TicketUpdate = New-NinjaOnePUTRequest @RequestParams
                if ($TicketUpdate -eq 204) {
                    Write-Information 'Ticket updated successfully.'
                }
            }
        } else {
            throw "Ticket $ticketId does not exist."
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}