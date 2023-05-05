function Get-NinjaOneTickets {
    <#
        .SYNOPSIS
            Gets boards from the NinjaOne API.
        .DESCRIPTION
            Retrieves boards from the NinjaOne v2 API.
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
        # Any filters to apply to the request.
        [Parameter(ParameterSetName = 'Board')]
        [hashtable]$filters = @{},
        # Return the full response including metadata
        [Parameter(ParameterSetName = 'Board')]
        [switch]$includeMetadata
    )
    if ($Script:NRAPIConnectionInformation.AuthMode -eq 'Client Credentials') {
        throw ('This function is not available when using client_credentials authentication. Please report this to api@ninjarmm.com.')
        exit 1
    }
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'ticketId=' parameter by removing it from the set parameters.
    if ($ticketId) {
        $Parameters.Remove('ticketId') | Out-Null
    }
    # Workaround to prevent the query string processor from adding an 'boardid=' parameter by removing it from the set parameters.
    if ($boardId) {
        $Parameters.Remove('boardId') | Out-Null
    }
    # Workaround to prevent the query string processor from adding an 'includemetadata=' parameter by removing it from the set parameters.
    if ($includeMetadata) {
        $Parameters.Remove('includeMetadata') | Out-Null
    }
    try {
        if ($ticketId) {
            Write-Verbose "Retrieving information on ticket with id $($deviceId)"
            $Resource = "v2/ticketing/ticket/$($ticketId)"
        } else {
            Write-Verbose 'Retrieving tickets for board with id $($boardId)'
            $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
            $Resource = "v2/ticketing/trigger/board/$($boardId)/run"
        }
        $RequestParams = @{
            Resource = $Resource
        }
        if ($QSCollection) {
            $RequestParams.QSCollection = $QSCollection
        }
        if ($filters) {
            $RequestParams.Body = $filters
        }   
        $Tickets = New-NinjaOnePOSTRequest @RequestParams
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