function Get-NinjaOneContacts {
    <#
        .SYNOPSIS
            Gets contacts from the NinjaOne API.
        .DESCRIPTION
            Retrieves contacts from the NinjaOne v2 API.
        .FUNCTIONALITY
            Contacts
        .EXAMPLE
            PS> Get-NinjaOneContacts
            
            Gets all contacts.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/contacts
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param()
    if ($Script:NRAPIConnectionInformation.AuthMode -eq 'Client Credentials') {
        throw ('This function is not available when using client_credentials authentication. If this is unexpected please report this to api@ninjarmm.com.')
        exit 1
    }
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = 'v2/ticketing/contact/contacts'
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $Contacts = New-NinjaOneGETRequest @RequestParams
        if ($Contacts) {
            return $Contacts
        } else {
            throw 'No contacts found.'
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}