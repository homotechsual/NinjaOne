
function Get-NinjaOneUsers {
    <#
        .SYNOPSIS
            Gets users from the NinjaOne API.
        .DESCRIPTION
            Retrieves users from the NinjaOne v2 API.
        .EXAMPLE
            PS> Get-NinjaOneUsers
            
            Gets all users.
        .EXAMPLE
            PS> Get-NinjaOneUsers -userType TECHNICIAN
            
            Gets all technicians (users with the TECHNICIAN user type).
        .EXAMPLE
            PS> Get-NinjaOneUsers -organisationID 1
            
            Gets all users for the organisation with ID 1 (only works for users with the END_USER user type).
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
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('id', 'organizationId')]
        [Int]$organisationId
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        if ($organisationID) {
            Write-Verbose 'Getting organisation from NinjaOne API.'
            $Organisation = Get-NinjaOneOrganisations -organisationID $organisationID
            if ($Organisation) {
                Write-Verbose "Retrieving users for $($Organisation.Name)."
                $Resource = "v2/organization/$($organisationID)/end-users"
            } 
        } else {
            Write-Verbose 'Retrieving all users.'
            $Resource = 'v2/users'
        }
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $UserResults = New-NinjaOneGETRequest @RequestParams
        Return $UserResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}