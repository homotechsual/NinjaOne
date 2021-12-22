
using namespace System.Management.Automation
#Requires -Version 7
function Get-NinjaOneSoftwareInventoryReport {
    <#
        .SYNOPSIS
            Gets the software inventory report from the NinjaOne API.
        .DESCRIPTION
            Retrieves the software inventory report from the NinjaOne v2 API.
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
        [Int]$pageSize,
        # Filter sofware to those installed before this date.
        [DateTime]$installedBefore,
        # Filter software to those installed after this date.
        [DateTime]$installedAfter
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = 'v2/queries/software'
        $RequestParams = @{
            Method = 'GET'
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $SoftwareInventoryReport = New-NinjaOneGETRequest @RequestParams
        Return $SoftwareInventoryReport
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