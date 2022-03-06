
using namespace System.Management.Automation
#Requires -Version 7
function Get-NinjaOneBoards {
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
    Param()
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = 'v2/ticketing/trigger/boards'
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $Boards = New-NinjaOneGETRequest @RequestParams
        Return $Boards
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}