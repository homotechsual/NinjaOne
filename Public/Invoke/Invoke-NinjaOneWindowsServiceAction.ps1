function Invoke-NinjaOneWindowsServiceAction {
    <#
        .SYNOPSIS
            Runs an action against the given Windows Service for the given device.
        .DESCRIPTION
            Runs an action against a windows service on a single device using the NinjaOne v2 API.
        .FUNCTIONALITY
            Invoke Windows Service Action
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The device(s) to change service configuration for.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [int]$deviceId,
        # The service to alter configuration for.
        [Parameter(Mandatory, Position = 1)]
        [string]$serviceId,
        # The action to invoke.
        [Parameter(Mandatory, Position = 2)]
        [ValidateSet('START', 'PAUSE', 'STOP', 'RESTART')]
        [string]$action
    )
    try {
        $Device = Get-NinjaOneDevice -deviceId $deviceId
        if ($Device) {
            Write-Verbose ('Performing action {0} on service {1} on device {2}.' -f $action, $serviceId, $Device.SystemName)
            $Resource = ('v2/device/{0}/windows-service/{1}/control' -f $deviceId, $serviceId)
        } else {
            throw ('Device with id {0} not found.' -f $deviceId)
        }
        $RequestParams = @{
            Resource = $Resource
            Body = @{
                action = $action
            }
        }
        if ($PSCmdlet.ShouldProcess("Service $($serviceId) configuration", 'Set')) {
            $ServiceAction = New-NinjaOnePOSTRequest @RequestParams
            if ($ServiceAction -eq 204) {
                $OIP = $InformationPreference
                $InformationPreference = 'Continue'
                Write-Information ('Requested {0} on service {1} on device {2} successfully.' -f $action, $serviceId, $deviceId)
                $InformationPreference = $OIP
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}