function New-NinjaOneTicket {
    <#
        .SYNOPSIS
            Creates a new ticket using the NinjaOne API.
        .DESCRIPTION
            Create a ticket using the NinjaOne v2 API.
        .FUNCTIONALITY
            Ticket
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/ticket
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([Object])]
    [Alias('nnot')]
    [Metadata(
        '/v2/ticketing/ticket',
        'post'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # An object containing the ticket to create.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Object]$ticket,
        # Show the ticket that was created.
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
            $Resource = 'v2/ticketing/ticket'
            $RequestParams = @{
                Resource = $Resource
                Body = $ticket
            }
            if ($PSCmdlet.ShouldProcess(('Ticket {0}' -f $ticket.Subject), 'Create')) {
                $TicketCreate = New-NinjaOnePOSTRequest @RequestParams
                if ($show) {
                    return $TicketCreate
                } else {
                    $OIP = $InformationPreference
                    $InformationPreference = 'Continue'
                    Write-Information ('Ticket {0} created.' -f $TicketCreate.Subject)
                    $InformationPreference = $OIP
                }
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}