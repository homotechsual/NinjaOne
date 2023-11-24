
function Get-NinjaOneRoles {
    <#
        .SYNOPSIS
            Gets device roles from the NinjaOne API.
        .DESCRIPTION
            Retrieves device roles from the NinjaOne v2 API.
        .FUNCTIONALITY
            Device Roles
        .EXAMPLE
            PS> Get-NinjaOneRoles

            Gets all device roles.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/deviceroles
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param()
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        Write-Verbose 'Retrieving all roles.'
        $Resource = 'v2/roles'
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $RoleResults = New-NinjaOneGETRequest @RequestParams
        if ($RoleResults) {
            return $RoleResults
        } else {
            throw 'No roles found.'
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}