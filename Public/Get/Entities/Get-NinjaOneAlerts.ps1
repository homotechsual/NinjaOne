using namespace System.Management.Automation
#Requires -Version 7
function Get-NinjaOneAlerts {
    <#
        .SYNOPSIS
            Gets alerts from the NinjaOne API.
        .DESCRIPTION
            Retrieves alerts from the NinjaOne v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Filter by source type.
        [String]$sourceType,
        # Filter by device which triggered the alert.
        [Alias('df')]
        [String]$deviceFilter,
        # Filter by language tag.
        [Alias('lang')]
        [String]$languageTag,
        # Filter by timezone.
        [Alias('tz')]
        [String]$timeZone,
        # Filter by device ID.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [Int]$deviceId
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'deviceid=' parameter by removing it from the set parameters.
    if ($deviceId) {
        $Parameters.Remove('deviceID') | Out-Null
    }
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        if ($deviceId) {
            Write-Verbose 'Getting device from NinjaOne API.'
            $Device = Get-NinjaOneDevices -deviceID $deviceId
            if ($Device) {
                Write-Verbose "Retrieving alerts for $($Device.SystemName)."
                $Resource = "v2/device/$($deviceId)/alerts"
            }
        } else {
            Write-Verbose 'Retrieving all alerts.'
            $Resource = 'v2/alerts'
        }
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $AlertResults = New-NinjaOneGETRequest @RequestParams
        Return $AlertResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}