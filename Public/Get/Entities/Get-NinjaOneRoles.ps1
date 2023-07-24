
function Get-NinjaOneRoles {
    <#
        .SYNOPSIS
            Gets device roles from the NinjaOne API.
        .DESCRIPTION
            Retrieves device roles from the NinjaOne v2 API.
        .EXAMPLE
            PS> Get-NinjaOneRoles

            Gets all device roles.
        .OUTPUTS
            A powershell object containing the response.
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
        Return $RoleResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}