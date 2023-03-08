function Set-NinjaOneWindowsServiceConfiguration {
    <#
        .SYNOPSIS
            Sets the configuration of the given Windows Service for the given device.
        .DESCRIPTION
            Sets the configuration of the Windows Service for a single device using the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
        .EXAMPLE
            Set-NinjaOneWindowsServiceConfiguration -deviceId "12345" -serviceId "NinjaRMMAgent" -Configuration @{ startType = "AUTO_START"; userName = "LocalSystem" }
    #>
    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The device to change servce configuration for.
        [Parameter(Mandatory = $true)]
        [string[]]$deviceId,
        # The service to alter configuration for.
        [Parameter(Mandatory = $true)]
        [object]$serviceId,
        # The configuration to set.
        [Parameter(Mandatory = $true)]
        [object]$configuration
    )
    try {
        $Resource = "v2/device/$deviceId/windows-service/$serviceId/configure"
        $RequestParams = @{
            Resource = $Resource
            Body = $configuration
        }
        if ($PSCmdlet.ShouldProcess("Service $serviceId configuration", 'Set')) {
            $ServiceConfiguration = New-NinjaOnePOSTRequest @RequestParams
            if ($InformationPreference -eq 'Continue' -and $ServiceConfiguration -eq 204) {
                Write-Information "Service configuration for service $($serviceId) on device $($deviceId) updated successfully." -InformationAction Continue
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}