
using namespace System.Management.Automation
#Requires -Version 7
function Get-NinjaOneLoggedOnUsers {
    <#
        .SYNOPSIS
            Gets the logged on users from the NinjaOne API.
        .DESCRIPTION
            Retrieves the logged on users from the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Filter devices.
        [Alias('df')]
        [String]$deviceFilter,
        # Cursor name.
        [String]$cursor,
        # Number of results per page.
        [Int]$pageSize
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = 'v2/queries/logged-on-users'
        $RequestParams = @{
            Method = 'GET'
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $LoggedOnUsers = New-NinjaOneGETRequest @RequestParams
        Return $LoggedOnUsers
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}