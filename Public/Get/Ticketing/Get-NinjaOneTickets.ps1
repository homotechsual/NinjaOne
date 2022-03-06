
using namespace System.Management.Automation
#Requires -Version 7
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
        # The board ID to get tickets for.
        [Parameter(Mandatory = $true)]
        [string]$boardID,
        [hashtable]$filters = @{}
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'boardid=' parameter by removing it from the set parameters.
    if ($boardID) {
        $Parameters.Remove('boardID') | Out-Null
    }
    try {   
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = "v2/ticketing/trigger/board/$boardID/run"
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
            Body = $filters
        }
        $Tickets = New-NinjaOnePOSTRequest @RequestParams
        Return $Tickets
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}