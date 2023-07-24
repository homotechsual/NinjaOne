function Get-NinjaOneTickets {
    <#
        .SYNOPSIS
            Gets tickets from the NinjaOne API.
        .DESCRIPTION
            Retrieves tickets from the NinjaOne v2 API.
        .EXAMPLE
            PS> Get-NinjaOneTickets -ticketId 1

            Gets the ticket with id 1.
        .EXAMPLE
            PS> Get-NinjaOneTickets -boardId 1

            Gets all tickets for the board with id 1.
        .EXAMPLE
            PS> Get-NinjaOneTickets -boardId 1 -filters @{status = 'open'}

            Gets all open tickets for the board with id 1.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The ticket ID to get.
        [Parameter(ParameterSetName = 'Single', Mandatory)]
        [int]$ticketId,
        # The board ID to get tickets for.
        [Parameter(ParameterSetName = 'Board', Mandatory)]
        [string]$boardId,
        # The sort rules to apply to the request.
        [Parameter(ParameterSetName = 'Board')]
        [NinjaOneTicketBoardSort[]]$sort,
        # Any filters to apply to the request.
        [Parameter(ParameterSetName = 'Board')]
        [NinjaOneTicketBoardFilter[]]$filters,
        # The last cursor id to use for the request.
        [Parameter(ParameterSetName = 'Board')]
        [string]$lastCursorId,
        # The number of results to return.
        [Parameter(ParameterSetName = 'Board')]
        [int]$pageSize,
        # The search criteria to apply to the request.
        [Parameter(ParameterSetName = 'Board')]
        [string]$searchCriteria
    )
    if ($Script:NRAPIConnectionInformation.AuthMode -eq 'Client Credentials') {
        throw ('This function is not available when using client_credentials authentication. If this is unexpected please report this to api@ninjarmm.com.')
        exit 1
    }
    try {
        if ($ticketId) {
            Write-Verbose "Retrieving information on ticket with id $($deviceId)"
            $Resource = "v2/ticketing/ticket/$($ticketId)"
            $Method = 'GET'
        } else {
            Write-Verbose 'Retrieving tickets for board with id $($boardId)'
            $Resource = "v2/ticketing/trigger/board/$($boardId)/run"
            $Method = 'POST'
        }
        $RequestParams = @{
            Resource = $Resource
        }
        if ($QSCollection) {
            $RequestParams.QSCollection = $QSCollection
        }
        if ($sort -or $filters -or $lastCursorId -or $searchCriteria) {
            $RequestParams.Body = [hashtable]@{}
        }
        if ($sort) {
            $RequestParams.Body.sort = $sort
        }
        if ($filters) {
            $RequestParams.Body.filters = $filters
        }
        if ($lastCursorId) {
            $RequestParams.Body.lastCursorId = $lastCursorId
        }
        if ($searchCriteria) {
            $RequestParams.Body.searchCriteria = $searchCriteria
        }
        if ($Method -eq 'GET') {
            $Tickets = New-NinjaOneGETRequest @RequestParams
        } elseif ($Method -eq 'POST') {
            $Tickets = New-NinjaOnePOSTRequest @RequestParams
        }
        if ($includeMetadata) {
            Return $Tickets
        } else {
            # Return just the `data` property which lists the tickets.
            Return $Tickets.data
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}