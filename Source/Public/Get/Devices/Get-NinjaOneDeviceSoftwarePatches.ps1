
function Get-NinjaOneDeviceSoftwarePatches {
    <#
        .SYNOPSIS
            Gets device Software patches from the NinjaOne API.
        .DESCRIPTION
            Retrieves device Software patches from the NinjaOne v2 API. If you want patch information for multiple devices please check out the related 'queries' commandlet `Get-NinjaOneSoftwarePatches`.
        .FUNCTIONALITY
            Device Software Patches
        .EXAMPLE
            PS> Get-NinjaOneDeviceSoftwarePatches -deviceId 1

            Gets all software patches for the device with id 1.
        .EXAMPLE
            PS> Get-NinjaOneDeviceSoftwarePatches -deviceId 1 -status 'APPROVED' -type 'PATCH' -impact 'CRITICAL'

            Gets all software patches for the device with id 1 where the patch is approved, has type patch and has critical impact/severity.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicesoftwarepatches
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Device id to get software patch information for.
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [Int]$deviceId,
        # Filter patches by patch status.
        [Parameter(Position = 1)]
        [ValidateSet('MANUAL', 'APPROVED', 'FAILED', 'REJECTED')]
        [String]$status,
        # Filter patches by product identifier.
        [Parameter(Position = 2)]
        [string]$productIdentifier,
        # Filter patches by type.
        [Parameter(Position = 3)]
        [ValidateSet('PATCH', 'INSTALLER')]
        [String]$type,
        # Filter patches by impact.
        [Parameter(Position = 4)]
        [ValidateSet('OPTIONAL', 'RECOMMENDED', 'CRITICAL')]
        [String]$impact
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'deviceid=' parameter by removing it from the set parameters.
    $Parameters.Remove('deviceId') | Out-Null
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        Write-Verbose 'Getting device from NinjaOne API.'
        $Device = Get-NinjaOneDevices -deviceId $deviceId
        if ($Device) {
            Write-Verbose ('Getting software patches for device {0}.' -f $Device.SystemName)
            $Resource = ('v2/device/{0}/software-patches' -f $deviceId)
        } else {
            throw ('Device with id {0} not found.' -f $deviceId)
        }
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $DeviceSoftwarePatchResults = New-NinjaOneGETRequest @RequestParams
        return $DeviceSoftwarePatchResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}