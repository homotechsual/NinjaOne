
function Get-NinjaOneUsers {
    <#
        .SYNOPSIS
            Gets users from the NinjaOne API.
        .DESCRIPTION
            Retrieves users from the NinjaOne v2 API.
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
        [Alias('id', 'organizationID')]
        [Int]$organisationID
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