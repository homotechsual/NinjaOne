using namespace System.Management.Automation
#Requires -Version 7
function Get-NinjaRMMAlerts {
    <#
        .SYNOPSIS
            Gets alerts from the NinjaRMM API.
        .DESCRIPTION
            Retrieves alerts from the NinjaRMM v2 API.
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
        [Int]$deviceID
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'deviceid=' parameter by removing it from the set parameters.
    if ($deviceID) {
        $Parameters.Remove('deviceID') | Out-Null
    }
    try {
        $QSCollection = New-NinjaRMMQuery -CommandName $CommandName -Parameters $Parameters
        if ($deviceID) {
            Write-Verbose 'Getting device from NinjaRMM API.'
            $Device = Get-NinjaRMMDevices -deviceID $deviceID
            if ($Device) {
                Write-Verbose "Retrieving alerts for $($Device.SystemName)."
                $Resource = "v2/device/$($deviceID)/alerts"
            }
        } else {
            Write-Verbose 'Retrieving all alerts.'
            $Resource = 'v2/alerts'
        }
        $RequestParams = @{
            Method = 'GET'
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $AlertResults = New-NinjaRMMGETRequest @RequestParams
        Return $AlertResults
    } catch {
        $ErrorRecord = @{
            ExceptionType = 'System.Exception'
            ErrorRecord = $_
            ErrorCategory = 'ReadError'
            BubbleUpDetails = $True
            CommandName = $CommandName
        }
        New-NinjaRMMError @ErrorRecord
    }
}