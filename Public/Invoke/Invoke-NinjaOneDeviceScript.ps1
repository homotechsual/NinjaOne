function Invoke-NinjaOneDeviceScript {
    <#
        .SYNOPSIS
            Runs a script or built-in action against the given device.
        .DESCRIPTION
            Runs a script or built-in action against a single device using the NinjaOne v2 API.
        .FUNCTIONALITY
            Run Script or Action
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # The device to run a script on.
        [Parameter(Mandatory = $true)]
        [string[]]$deviceId,
        # The type - script or action.
        [Parameter(Mandatory = $true)]
        [ValidateSet('SCRIPT', 'ACTION')]
        [object]$type,
        # The id of the script to run. Only used if the type is script.
        [Parameter()]
        [int]$scriptId,
        # The unique id of the action to run. Only used if the type is action.
        [Parameter()]
        [string]$actionId,
        # The parameters to pass to the script or action.
        [Parameter()]
        [string]$parameters,
        # The credential/role identifier to use when running the script.
        [Parameter()]
        [string]$runAs
    )
    if ($Script:NRAPIConnectionInformation.AuthMode -eq 'Client Credentials') {
        throw ('This function is not available when using client_credentials authentication. If this is unexpected please report this to api@ninjarmm.com.')
        exit 1
    }
    try {
        $Device = Get-NinjaOneDevice -deviceId $deviceId
        if ($Device) {
            $Resource = ('v2/device/{0}/script/run' -f $deviceId)
            $RunRequest = @{
                type = $action
            }
            if ($scriptId) {
                $RunRequest.id = $scriptId
            }
            if ($actionId) {
                $RunRequest.uid = $actionId
            }
            if ($parameters) {
                $RunRequest.parameters = $parameters
            }
            if ($runAs) {
                $RunRequest.runAs = $runAs
            }
            Write-Verbose ('Raw run request: {0}' -f ($RunRequest | Out-String))
        } else {
            throw ('Device with id {0} not found.' -f $deviceId)
        }
        $RequestParams = @{
            Resource = $Resource
            Body = $RunRequest
        }
        $ScriptRun = New-NinjaOnePOSTRequest @RequestParams
        if ($ScriptRun -eq 204) {
            if ($action -eq 'SCRIPT') {
                $actionResult = 'script'
            } else {
                $actionResult = 'action'
            }
            Write-Information "Requested run for $($actionResult) on device $($deviceId) successfully."
            $OIP = $InformationPreference
            $InformationPreference = 'Continue'
            Write-Information ('Requested run for {0} on device {1} successfully.' -f $actionResult, $deviceId)
            $InformationPreference = $OIP
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}