
using namespace System.Management.Automation
#Requires -Version 7
function Get-NinjaOneTicketForms {
    <#
        .SYNOPSIS
            Gets ticket forms from the NinjaOne API.
        .DESCRIPTION
            Retrieves ticket forms from the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param()
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = '/v2/ticketing/ticket-form'
        $RequestParams = @{
            Method = 'GET'
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $TicketForms = New-NinjaOneGETRequest @RequestParams
        Return $TicketForms
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}