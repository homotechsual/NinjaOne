using namespace System.Management.Automation
#Requires -Version 7
function Get-NinjaRMMCustomFieldsReport {
    <#
        .SYNOPSIS
            Gets the custom fields report from the NinjaRMM API.
        .DESCRIPTION
            Retrieves the custom fields report from the NinjaRMM v2 API.
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
        # Custom fields updated after the specified date.
        [DateTime]$updatedAfter,
        # Array of fields.
        [String[]]$fields,
        # Get the detailed version of this report.
        [Switch]$detailed
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaRMMQuery -CommandName $CommandName -Parameters $Parameters
        if ($detailed) {
            $Resource = 'v2/queries/custom-fields-detailed'
        } else {
            $Resource = 'v2/queries/custom-fields'
        }
        $RequestParams = @{
            Method = 'GET'
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $CustomFieldsReport = New-NinjaRMMGETRequest @RequestParams
        Return $CustomFieldsReport
    } catch {
        $ErrorRecord = @{
            ExceptionType = 'System.Exception'
            ErrorRecord = $_
            ErrorCategory = 'ReadError'
            BubbleUpDetails = $True
            CommandName = $CommandName
        }
        New-NinjaRMMError @ErrorRecord
    }
}