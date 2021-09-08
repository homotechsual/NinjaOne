#Requires -Version 7
function Get-NinjaRMMUsers {
    <#
        .SYNOPSIS
            Gets users from the NinjaRMM API.
        .DESCRIPTION
            Retrieves users from the NinjaRMM v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Filter by user type. This can be one of "TECHNICIAN" or "END_USER".
        [Parameter()]
        [ValidateSet(
            'TECHNICIAN',
            'END_USER'
        )]
        [String]$userType,
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
                Write-Verbose "Retrieving users for $($Organisation.Name)."
                $Resource = "v2/organization/$($organisationID)/end-users"
            } 
        } else {
            Write-Verbose 'Retrieving all users.'
            $Resource = 'v2/users'
        }
        $RequestParams = @{
            Method = 'GET'
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $UserResults = New-NinjaRMMGETRequest @RequestParams
        Return $UserResults
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