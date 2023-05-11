function Get-NinjaOneTicketAttributes {
    <#
        .SYNOPSIS
            Gets ticket attributes from the NinjaOne API.
        .DESCRIPTION
            Retrieves a list of the ticket attributes from the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param()
    #if ($Script:NRAPIConnectionInformation.AuthMode -eq 'Client Credentials') {
    #    throw ('This function is not available when using client_credentials authentication. Please report this to api@ninjarmm.com.')
    #    exit 1
    #}
    #$CommandName = $MyInvocation.InvocationName
    #$Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $Resource = 'v2/ticketing/attributes'
        $RequestParams = @{
            Resource = $Resource
        }
        $TicketAttributes = New-NinjaOneGETRequest @RequestParams
        return $TicketAttributes
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}