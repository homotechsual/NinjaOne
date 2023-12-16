function Get-NinjaOneTicketLogEntries {
    <#
        .SYNOPSIS
            Gets ticket log entries from the NinjaOne API.
        .DESCRIPTION
            Retrieves ticket log entries from the NinjaOne v2 API.
        .FUNCTIONALITY
            Ticket Log Entries
        .EXAMPLE
            PS> Get-NinjaOneTicketLogEntries -ticketId 1

            Gets all ticket log entries for ticket with id 1.
        .EXAMPLE
            PS> Get-NinjaOneTicketLogEntries -ticketId 1 -type DESCRIPTION

            Gets all ticket log entries for ticket with id 1 with type DESCRIPTION.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/ticketlogentries
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Alias('gnotle')]
    [Metadata(
        '/v2/ticketing/ticket/{ticketId}/log-entry',
        'get'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Filter by ticket id.
        [Parameter(Mandatory)]
        [Alias('id')]
        [String]$ticketId,
        # Filter log entries by type.
        [ValidateSet('DESCRIPTION', 'COMMENT', 'CONDITION', 'SAVE', 'DELETE')]
        [String]$type
    )
    begin {
        if ($Script:NRAPIConnectionInformation.AuthMode -eq 'Client Credentials') {
            throw ('This function is not available when using client_credentials authentication. If this is unexpected please report this to api@ninjarmm.com.')
            exit 1
        }
        $CommandName = $MyInvocation.InvocationName
        $Parameters = (Get-Command -Name $CommandName).Parameters
        # Workaround to prevent the query string processor from adding an 'ticketid=' parameter by removing it from the set parameters.
        $Parameters.Remove('ticketId') | Out-Null
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
    }
    process {
        try {
            $Resource = ('v2/ticketing/ticket/{0}/log-entry' -f $ticketId)
            $RequestParams = @{
                Resource = $Resource
                QSCollection = $QSCollection
            }
            $TicketLogEntries = New-NinjaOneGETRequest @RequestParams
            if ($TicketLogEntries) {
                return $TicketLogEntries
            } else {
                if ($type) {
                    throw ('No ticket log entries found for ticket {0} with type {1}.' -f $ticketId, $type)
                } else {
                    throw ('No ticket log entries found for ticket {0}.' -f $ticketId)
                }
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}