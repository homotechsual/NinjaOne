function Get-NinjaOneTicketForms {
    <#
        .SYNOPSIS
            Gets ticket forms from the NinjaOne API.
        .DESCRIPTION
            Retrieves ticket forms from the NinjaOne v2 API.
        .EXAMPLE
            PS> Get-NinjaOneTicketForms

            Gets all ticket forms.
        .EXAMPLE
            PS> Get-NinjaOneTicketForms -ticketFormId 1

            Gets ticket form with id 1.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Ticket form ID.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [Int]$ticketFormId
    )
    if ($Script:NRAPIConnectionInformation.AuthMode -eq 'Client Credentials') {
        throw ('This function is not available when using client_credentials authentication. If this is unexpected please report this to api@ninjarmm.com.')
        exit 1
    }
    try {
        if ($ticketFormId) {
            Write-Verbose "Retrieving information on ticket form with id $($ticketFormId)"
            $Resource = "/v2/ticketing/ticket-form/$($ticketFormId)"
        } else {
            Write-Verbose 'Retrieving ticket forms'
            $Resource = '/v2/ticketing/ticket-form'
        }
        $RequestParams = @{
            Resource = $Resource
        }
        $TicketForms = New-NinjaOneGETRequest @RequestParams
        Return $TicketForms
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}