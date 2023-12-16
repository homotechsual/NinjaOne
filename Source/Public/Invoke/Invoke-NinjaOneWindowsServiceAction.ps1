function Invoke-NinjaOneWindowsServiceAction {
    <#
        .SYNOPSIS
            Runs an action against the given Windows Service for the given device.
        .DESCRIPTION
            Runs an action against a windows service on a single device using the NinjaOne v2 API.
        .FUNCTIONALITY
            Windows Service Action
        .OUTPUTS
            System.Void

            This commandlet returns no output. A success message will be written to the information stream if the API returns a 204 success code. Use `-InformationAction Continue` to see this message.
        .EXAMPLE

        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/windowsserviceaction
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    # This commandlet returns no output. A success message will be written to the information stream if the API returns a 204 success code. Use `-InformationAction Continue` to see this message.
    [OutputType([System.Void])]
    [Alias('inowsa')]
    [Metadata(
        '/v2/device/{id}/windows-service/{serviceId}/control',
        'post'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The device(s) to change service configuration for.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [int]$deviceId,
        # The service to alter configuration for.
        [Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
        [Alias('service', 'serviceName')]
        [string]$serviceId,
        # The action to invoke.
        [Parameter(Mandatory, Position = 2, ValueFromPipelineByPropertyName)]
        [ValidateSet('START', 'PAUSE', 'STOP', 'RESTART')]
        [string]$action
    )
    process {
        try {
            $Device = Get-NinjaOneDevice -deviceId $deviceId
            if ($Device) {
                $Service = Get-NinjaOneDeviceWindowsServices -deviceId $deviceId -name $serviceId
                if ($Service) {
                    Write-Verbose ('Performing action {0} on service {1} on device {2}.' -f $action, $Service.DisplayName, $Device.SystemName)
                    $Resource = ('v2/device/{0}/windows-service/{1}/control' -f $deviceId, $serviceId)
                } else {
                    throw ('Service with id {0} not found.' -f $serviceId)
                }
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
                    Write-Information ('Requested {0} on service {1} on device {2} successfully.' -f $action, $serviceId, $deviceId)
                }
            }
        } catch {
            New-NinjaOneError -ErrorRecord $_
        }
    }
}