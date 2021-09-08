#Requires -Version 7
function Get-NinjaRMMLocations {
    <#
        .SYNOPSIS
            Gets locations from the NinjaRMM API.
        .DESCRIPTION
            Retrieves locations from the NinjaRMM v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Number of results per page.
        [Int]$pageSize,
        # Start results from location ID.
        [Int]$after,
        # Filter by organisation ID.
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        [Alias('id', 'organizationID')]
        [Int]$organisationID
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaRMMQuery -CommandName $CommandName -Parameters $Parameters
        if ($organisationID) {
            Write-Verbose 'Getting organisation from NinjaRMM API.'
            $Organisation = Get-NinjaRMMOrganisations -organisationID $organisationID
            if ($Organisation) {
                Write-Verbose "Retrieving locations for $($Organisation.Name)."
                $Resource = "v2/organization/$($organisationID)/locations"
            }
        } else {
            Write-Verbose 'Retrieving all locations.'
            $Resource = 'v2/locations'
        }
        $RequestParams = @{
            Method = 'GET'
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $LocationResults = New-NinjaRMMGETRequest @RequestParams
        Return $LocationResults
    } catch {
        $ErrorRecord = @{
            ExceptionType = 'System.Exception'
            ErrorRecord = $_
            ErrorCategory = 'ReadError'
            BubbleUpDetails = $True
            CommandName = $CommandName
        }
        New-NinjaRMMError @ErrorRecord
    }
}