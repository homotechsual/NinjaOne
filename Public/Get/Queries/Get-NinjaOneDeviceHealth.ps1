function Get-NinjaOneDeviceHealth {
    <#
        .SYNOPSIS
            Gets the device health from the NinjaOne API.
        .DESCRIPTION
            Retrieves the device health from the NinjaOne v2 API.
        .FUNCTIONALITY
            Device Health Query
        .EXAMPLE
            PS> Get-NinjaOneDeviceHealth

            Gets the device health.
        .EXAMPLE
            PS> Get-NinjaOneDeviceHealth -deviceFilter 'org = 1'

            Gets the device health for the organisation with id 1.
        .EXAMPLE
            PS> Get-NinjaOneDeviceHealth -health 'UNHEALTHY'

            Gets the device health for devices with the health status 'UNHEALTHY'.
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
        # Filter by health status.
        [ValidateSet('UNHEALTHY', 'HEALTHY', 'UNKNOWN', 'NEEDS_ATTENTION')]
        [String]$health,
        # Cursor name.
        [String]$cursor,
        # Number of results per page.
        [Int]$pageSize
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        $Resource = 'v2/queries/device-health'
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $DeviceHealth = New-NinjaOneGETRequest @RequestParams
        Return $DeviceHealth
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}