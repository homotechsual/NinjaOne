function Get-NinjaOneTicketAttributes {
    <#
        .SYNOPSIS
            Gets ticket attributes from the NinjaOne API.
        .DESCRIPTION
            Retrieves a list of the ticket attributes from the NinjaOne v2 API.
        .FUNCTIONALITY
            Ticket Attributes
        .EXAMPLE
            PS> Get-NinjaOneTicketAttributes

            Gets all ticket attributes.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/ticketattributes
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Alias('gnota')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param()
    begin {
        $CommandName = $MyInvocation.InvocationName
        $Parameters = (Get-Command -Name $CommandName).Parameters
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
    }
    process {
        try {
            $Resource = 'v2/ticketing/attributes'
            $RequestParams = @{
                QSCollection = $QSCollection
                Resource = $Resource
            }
            $TicketAttributes = New-NinjaOneGETRequest @RequestParams
            if ($TicketAttributes) {
                return $TicketAttributes
            } else {
                throw 'No ticket attributes found.'
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}