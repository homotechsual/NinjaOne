
function Get-NinjaOneActivities {
    <#
        .SYNOPSIS
            Gets activities from the NinjaOne API.
        .DESCRIPTION
            Retrieves activities from the NinjaOne v2 API.
        .EXAMPLE
            PS> Get-NinjaOneActivities

            Gets all activities.
        .EXAMPLE
            PS> Get-NinjaOneActivities -deviceId 1

            Gets activities for the device with id 1.
        .EXAMPLE
            PS> Get-NinjaOneActivities -class SYSTEM

            Gets system activities.
        .EXAMPLE
            PS> Get-NinjaOneActivities -before ([DateTime]::Now.AddDays(-1))

            Gets activities from before yesterday.
        .EXAMPLE
            PS> Get-NinjaOneActivities -after ([DateTime]::Now.AddDays(-1))

            Gets activities from after yesterday.
        .EXAMPLE
            PS> Get-NinjaOneActivities -olderThan 1

            Gets activities older than activity id 1.
        .EXAMPLE
            PS> Get-NinjaOneActivities -newerThan 1

            Gets activities newer than activity id 1.
        .EXAMPLE
            PS> Get-NinjaOneActivities -type 'Action'

            Gets activities of type 'Action'.
        .EXAMPLE
            PS> Get-NinjaOneActivities -status 'COMPLETED'

            Gets activities with status 'COMPLETED'.
        .EXAMPLE
            PS> Get-NinjaOneActivities -seriesUid '23e4567-e89b-12d3-a456-426614174000'

            Gets activities for the alert series with uid '23e4567-e89b-12d3-a456-426614174000'.
        .EXAMPLE
            PS> Get-NinjaOneActivities -deviceFilter 'organization in (1,2,3)'

            Gets activities for devices in organisations 1, 2 and 3.
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
        [Int]$deviceId,
        # Activity class.
        [ValidateSet('SYSTEM', 'DEVICE', 'USER', 'ALL')]
        [String]$class,
        # Return activities from before this date. PowerShell DateTime object.
        [DateTime]$before,
        # Return activities from before this date. Unix Epoch time.
        [Int]$beforeUnixEpoch,
        # Return activities from after this date. PowerShell DateTime object.
        [DateTime]$after,
        # Return activities from after this date. Unix Epoch time.
        [Int]$afterUnixEpoch,
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
    if ($before) {
        [Int]$before = ConvertTo-UnixEpoch -DateTime $before
    }
    if ($beforeUnixEpoch) {
        $Parameters.Remove('beforeUnixEpoch') | Out-Null
        [Int]$before = $beforeUnixEpoch
    }
    if ($after) {
        [Int]$after = ConvertTo-UnixEpoch -DateTime $after
    }
    if ($afterUnixEpoch) {
        $Parameters.Remove('afterUnixEpoch') | Out-Null
        [Int]$after = $afterUnixEpoch
    }
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        if ($deviceId) {
            Write-Verbose 'Getting device from NinjaOne API.'
            $Device = Get-NinjaOneDevices -deviceID $deviceId
            if ($Device) {
                Write-Verbose "Retrieving activities for $($Device.SystemName)."
                $Resource = "v2/device/$($deviceId)/activities"
            }
        } else {
            Write-Verbose 'Retrieving all device activities.'
            $Resource = 'v2/activities'
        }
        $RequestParams = @{
            Resource = $Resource
            QSCollection = $QSCollection
        }
        $ActivityResults = New-NinjaOneGETRequest @RequestParams
        Return $ActivityResults
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}