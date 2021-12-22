
using namespace System.Management.Automation
#Requires -Version 7
function Get-NinjaOneWindowsServicesReport {
    <#
        .SYNOPSIS
            Gets the windows services report from the NinjaOne API.
        .DESCRIPTION
            Retrieves the windows services report from the NinjaOne v2 API.
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
        # Filter by service name.
        [String]$name,
        # Filter by service state.
        [ValidateSet(
            'UNKNOWN',
            'STOPPED',
            'START_PENDING',
            'RUNNING',
            'STOP_PENDING',
            'PAUSE_PENDING',
            'PAUSED',
            'CONTINUE_PENDING'
        )]
        [String]$state,
        # Cursor name.
        [String]$cursor,
        # Number of results per page.
        [Int]$pageSize
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = 'v2/queries/windows-services'
        $RequestParams = @{
            Method = 'GET'
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $WindowsServicesReport = New-NinjaOneGETRequest @RequestParams
        Return $WindowsServicesReport
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