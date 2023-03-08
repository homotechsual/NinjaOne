function Set-NinjaOneDeviceApproval {
    <#
        .SYNOPSIS
            Sets the approval status of the specified device(s)
        .DESCRIPTION
            Sets the approval status of the specified device(s) using the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'Medium' )]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The approval mode.
        [Parameter(Mandatory = $true)]
        [ValidateSet('APPROVE', 'REJECT')]
        [string]$mode,
        # The device(s) to set the approval status for.
        [Parameter(Mandatory = $true)]
        [int[]]$deviceIds
    )
    try {
        $Resource = "v2/devices/approval/$mode"
        if ($deviceIds -is [array]) {
            $devices = @{
                'devices' = $deviceIds
            }
        } else {
            $devices = @{
                'devices' = @($deviceIds)
            }
        }
        $RequestParams = @{
            Resource = $Resource
            Body = $devices
        }
        if ($PSCmdlet.ShouldProcess('Device Approval', 'Set')) {
            $DeviceApprovals = New-NinjaOnePOSTRequest @RequestParams
            if ($DeviceApprovals -eq 204) {
                if ($mode -eq 'APPROVE') {
                    $approvalResult = 'approved'
                } else {
                    $approvalResult = 'rejected'
                }
                Write-Information "Devices $($deviceIds) $($approvalResult) successfully."
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}