function Get-NinjaOneOSPatches {
    <#
        .SYNOPSIS
            Gets the OS patches from the NinjaOne API.
        .DESCRIPTION
            Retrieves the OS patches from the NinjaOne v2 API.
        .EXAMPLE
            PS> Get-NinjaOneOSPatches

            Gets all OS patches.
        .EXAMPLE
            PS> Get-NinjaOneOSPatches -deviceFilter 'org = 1'

            Gets the OS patches for the organisation with id 1.
        .EXAMPLE
            PS> Get-NinjaOneOSPatches -timeStamp 1619712000

            Gets the OS patches with a monitoring timestamp at or after 1619712000.
        .EXAMPLE
            PS> Get-NinjaOneOSPatches -status 'APPROVED'

            Gets the OS patches with a status of APPROVED.
        .EXAMPLE
            PS> Get-NinjaOneOSPatches -type 'SECURITY_UPDATES'

            Gets the OS patches with a type of SECURITY_UPDATES.
        .EXAMPLE
            PS> Get-NinjaOneOSPatches -severity 'CRITICAL'

            Gets the OS patches with a severity of CRITICAL.
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
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $OSPatches = New-NinjaOneGETRequest @RequestParams
        Return $OSPatches
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}