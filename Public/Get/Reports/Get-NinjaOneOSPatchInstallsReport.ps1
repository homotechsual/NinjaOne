
using namespace System.Management.Automation
#Requires -Version 7
function Get-NinjaOneOSPatchInstallsReport {
    <#
        .SYNOPSIS
            Gets the OS patch installs report from the NinjaOne API.
        .DESCRIPTION
            Retrieves the OS patch installs report from the NinjaOne v2 API.
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
        # Monitoring timestamp filter.
        [Alias('ts')]
        [string]$timeStamp,
        # Filter patches by patch status.
        [ValidateSet('FAILED', 'INSTALLED')]
        [String]$status,
        # Filter patches to those installed before this date.
        [DateTime]$installedBefore,
        # Filter patches to those installed after this date.
        [DateTime]$installedAfter,
        # Cursor name.
        [String]$cursor,
        # Number of results per page.
        [Int]$pageSize
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = 'v2/queries/os-patch-installs'
        $RequestParams = @{
            Method = 'GET'
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $OSPatchInstallsReport = New-NinjaOneGETRequest @RequestParams
        Return $OSPatchInstallsReport
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