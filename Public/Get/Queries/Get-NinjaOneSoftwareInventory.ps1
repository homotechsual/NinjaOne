
using namespace System.Management.Automation
#Requires -Version 7
function Get-NinjaOneSoftwareInventory {
    <#
        .SYNOPSIS
            Gets the software inventory from the NinjaOne API.
        .DESCRIPTION
            Retrieves the software inventory from the NinjaOne v2 API.
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
        $SoftwareInventory = New-NinjaOneGETRequest @RequestParams
        Return $SoftwareInventory
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}