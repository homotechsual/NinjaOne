function Reset-NinjaOneDevicePolicyOverrides {
    <#
        .SYNOPSIS
            Resets (removes) device policy overrides using the NinjaOne API.
        .DESCRIPTION
            Resets (removes) all configured device policy overrides using the NinjaOne v2 API.
        .FUNCTIONALITY
            Device Policy Overrides
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The device ID to reset policy overrides for.
        [Parameter(Mandatory = $true)]
        [string]$deviceId
    )
    try {
        $Resource = "v2/device/$deviceId/policy/overrides"
        $RequestParams = @{
            Resource = $Resource
        }
        if ($PSCmdlet.ShouldProcess('Device Policy Overrides', 'Reset')) {
            $Alert = New-NinjaOneDELETERequest @RequestParams
            if ($Alert -eq 204) {
                Write-Information 'Device policy overrides reset successfully.'
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}