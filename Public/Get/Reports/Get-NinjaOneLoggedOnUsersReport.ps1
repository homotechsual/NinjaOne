
using namespace System.Management.Automation
#Requires -Version 7
function Get-NinjaOneLoggedOnUsersReport {
    <#
        .SYNOPSIS
            Gets the logged on users report from the NinjaOne API.
        .DESCRIPTION
            Retrieves the logged on users report from the NinjaOne v2 API.
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
        $LoggedOnUsersReport = New-NinjaOneGETRequest @RequestParams
        Return $LoggedOnUsersReport
    } catch {
        $ErrorRecord = @{
            ExceptionType = 'System.Exception'
            ErrorRecord = $_
            ErrorCategory = 'ReadError'
            BubbleUpDetails = $True
            CommandName = $CommandName
        }
        New-NinjaOneError @ErrorRecord
    }
}