
using namespace System.Management.Automation
#Requires -Version 7
function Get-NinjaOneOSPatchesReport {
    <#
        .SYNOPSIS
            Gets the OS patches report from the NinjaOne API.
        .DESCRIPTION
            Retrieves the OS patches report from the NinjaOne v2 API.
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
        [ValidateSet('MANUAL', 'APPROVED', 'FAILED', 'REJECTED')]
        [String]$status,
        # Filter patches by type.
        [ValidateSet('UPDATE_ROLLUPS', 'SECURITY_UPDATES', 'DEFINITION_UPDATES', 'CRITICAL_UPDATES', 'REGULAR_UPDATES', 'FEATURE_PACKS', 'DRIVER_UPDATES')]
        [String]$type,
        # Filter patches by severity.
        [ValidateSet('OPTIONAL', 'MODERATE', 'IMPORTANT', 'CRITICAL')]
        [String]$severity,
        # Cursor name.
        [String]$cursor,
        # Number of results per page.
        [Int]$pageSize
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = 'v2/queries/os-patches'
        $RequestParams = @{
            Method = 'GET'
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $OSPatchesReport = New-NinjaOneGETRequest @RequestParams
        Return $OSPatchesReport
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