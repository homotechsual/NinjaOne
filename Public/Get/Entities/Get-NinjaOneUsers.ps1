
function Get-NinjaOneUsers {
    <#
        .SYNOPSIS
            Gets users from the NinjaOne API.
        .DESCRIPTION
            Retrieves users from the NinjaOne v2 API.
        .FUNCTIONALITY
            Users
        .EXAMPLE
            PS> Get-NinjaOneUsers
            
            Gets all users.
        .EXAMPLE
            PS> Get-NinjaOneUsers -userType TECHNICIAN
            
            Gets all technicians (users with the TECHNICIAN user type).
        .EXAMPLE
            PS> Get-NinjaOneUsers -organisationId 1
            
            Gets all users for the organisation with id 1 (only works for users with the END_USER user type).
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/users
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Filter by user type. This can be one of "TECHNICIAN" or "END_USER".
        [Parameter(ParameterSetName = 'Default')]
        [ValidateSet(
            'TECHNICIAN',
            'END_USER'
        )]
        [String]$userType,
        # Get users for this organisation id.
        [Parameter(Mandatory, ParameterSetName = 'Organisation', Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id', 'organizationId')]
        [Int]$organisationId
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'organisationid=' parameter by removing it from the set parameters.
    if ($organisationId) {
        $Parameters.Remove('organisationId') | Out-Null
    }
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        if ($organisationId) {
            Write-Verbose 'Getting organisation from NinjaOne API.'
            $Organisation = Get-NinjaOneOrganisations -organisationId $organisationId
            if ($Organisation) {
                Write-Verbose ('Getting users for organisation {0}.' -f $Organisation.Name)
                $Resource = ('v2/organization/{0}/end-users' -f $organisationId)
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
        if ($UserResults) {
            return $UserResults
        } else {
            if ($Organisation) {
                throw ('No users found for organisation {0}.' -f $Organisation.Name)
            } else {
                throw 'No users found.'
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}