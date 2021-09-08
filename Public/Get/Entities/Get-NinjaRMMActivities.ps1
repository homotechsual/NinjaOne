#Requires -Version 7
function Get-NinjaRMMActivities {
    <#
        .SYNOPSIS
            Gets activities from the NinjaRMM API.
        .DESCRIPTION
            Retrieves activities from the NinjaRMM v2 API.
        .OUTPUTS
            A powershell object containing the response.
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Filter by device ID.
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [Int]$deviceID,
        # Activity class.
        [ValidateSet('SYSTEM', 'DEVICE', 'USER', 'ALL')]
        [String]$class,
        # Return activities from before this date.
        [DateTime]$before,
        # Return activities from after this date.
        [DateTime]$after,
        # Return activities older than this activity ID.
        [Int]$olderThan,
        # Return activities newer than this activity ID.
        [Int]$newerThan,
        # Return activities of this type.
        [String]$type,
        # Return activities with this status.
        [String]$status,
        # Return activities for this user.
        [String]$user,
        # Return activities for this alert series.
        [String]$seriesUid,
        # Return activities matching this device filter.
        [Alias('df')]
        [String]$deviceFilter,
        # Number of results per page.
        [Int]$pageSize,
        # Filter by language tag.
        [Alias('lang')]
        [String]$languageTag,
        # Filter by timezone.
        [Alias('tz')]
        [String]$timeZone
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    try {
        $QSCollection = New-NinjaRMMQuery -CommandName $CommandName -Parameters $Parameters
        if ($deviceID) {
            Write-Verbose 'Getting device from NinjaRMM API.'
            $Device = Get-NinjaRMMDevices -deviceID $deviceID
            if ($Device) {
                Write-Verbose "Retrieving activities for $($Device.SystemName)."
                $Resource = "v2/device/$($deviceID)/activities"
            }
        } else {
            Write-Verbose 'Retrieving all device activities.'
            $Resource = 'v2/activities'
        }
        $RequestParams = @{
            Method = 'GET'
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $ActivityResults = New-NinjaRMMGETRequest @RequestParams
        Return $ActivityResults
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