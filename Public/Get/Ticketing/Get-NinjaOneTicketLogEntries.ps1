
using namespace System.Management.Automation
#Requires -Version 7
function Get-NinjaOneTicketLogEntries {
    <#
        .SYNOPSIS
            Gets ticket log entries from the NinjaOne API.
        .DESCRIPTION
            Retrieves ticket log entries from the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Filter by ticket ID.
        [Alias('id')]
        [String]$ticketID,
        # Filter log entries by type.
        [ValidateSet('DESCRIPTION', 'COMMENT', 'CONDITION', 'SAVE', 'DELETE')]
        [String]$type
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'ticketid=' parameter by removing it from the set parameters.
    if ($boardID) {
        $Parameters.Remove('ticketID') | Out-Null
    }
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = "v2/ticketing/ticket/$ticketID/log-entry"
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $TicketLogEntries = New-NinjaOneGETRequest @RequestParams
        Return $TicketLogEntries
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}