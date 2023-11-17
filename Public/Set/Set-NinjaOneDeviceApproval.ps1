function Set-NinjaOneDeviceApproval {
    <#
        .SYNOPSIS
            Sets the approval status of the specified device(s)
        .DESCRIPTION
            Sets the approval status of the specified device(s) using the NinjaOne v2 API.
        .FUNCTIONALITY
            Device Approval
        .OUTPUTS
            A powershell object containing the response.
        .EXAMPLE
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The approval mode.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateSet('APPROVE', 'REJECT')]
        [String]$mode,
        # The device(s) to set the approval status for.
        [Parameter(Mandatory, Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id', 'ids')]
        [Int[]]$deviceIds
    )
    if ($Script:NRAPIConnectionInformation.AuthMode -eq 'Client Credentials') {
        throw ('This function is not available when using client_credentials authentication. If this is unexpected please report this to api@ninjarmm.com.')
        exit 1
    }
    try {
        $DeviceResults = foreach ($deviceId in $deviceIds) {
            $deviceId | Get-NinjaOneDevice
        }
        if ($DeviceResults.count -ne $deviceIds.count) {
            throw ('One or more of the specified id(s) was not found.')
        } else {
            $Resource = ('v2/devices/approval/{0}' -f $mode)
        }
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
                $OIP = $InformationPreference
                $InformationPreference = 'Continue'
                Write-Information ('Device(s) {0} {1} successfully.' -f (($DeviceResults | Select-Object -ExpandProperty SystemName) -join ', '), $approvalResult)
                $InformationPreference = $OIP
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}