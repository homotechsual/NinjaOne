function Set-NinjaOneTicket {
    <#
        .SYNOPSIS
            Sets a ticket.
        .DESCRIPTION
            Sets a ticket using the NinjaOne v2 API.
        .FUNCTIONALITY
            Ticket
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/ticket
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The ticket Id.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [Int]$ticketId,
        # The ticket object.
        [Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
        [Object]$ticket 
    )
    if ($Script:NRAPIConnectionInformation.AuthMode -eq 'Client Credentials') {
        throw ('This function is not available when using client_credentials authentication. If this is unexpected please report this to api@ninjarmm.com.')
        exit 1
    }
    try {
        $Ticket = Get-NinjaOneTickets -ticketId $ticketId
        if ($Ticket) {
            Write-Verbose ('Updating ticket {0}.' -f $Ticket.Subject)
            $Resource = "v2/ticketing/ticket/$ticketId"
        } else {
            throw ('Ticket with id { 0 } not found.' -f $ticketId)
        }
        $RequestParams = @{
            Resource = $Resource
            Body = $ticket
        }
        if ($PSCmdlet.ShouldProcess(('Ticket {0} ({1})' -f $Ticket.Subject, $ticketId), 'Update')) {
            $TicketUpdate = New-NinjaOnePUTRequest @RequestParams
            if ($TicketUpdate -eq 204) {
                $OIP = $InformationPreference
                $InformationPreference = 'Continue'
                Write-Information ('Ticket {0} ({1}) updated successfully.' -f $Ticket.Subject, $ticketId)
                $InformationPreference = $OIP
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}