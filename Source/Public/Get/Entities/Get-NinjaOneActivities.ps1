
function Get-NinjaOneActivities {
    <#
        .SYNOPSIS
            Gets activities from the NinjaOne API.
        .DESCRIPTION
            Retrieves activities from the NinjaOne v2 API.
        .FUNCTIONALITY
            Activities
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
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/activities
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
    Param(
        # Filter by device id.
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [Int]$deviceId,
        # Activity class.
        [Parameter(Position = 1)]
        [ValidateSet('SYSTEM', 'DEVICE', 'USER', 'ALL')]
        [String]$class,
        # return activities from before this date. PowerShell DateTime object.
        [Parameter(Position = 2)]
        [DateTime]$before,
        # return activities from before this date. Unix Epoch time.
        [Parameter(Position = 2)]
        [Int]$beforeUnixEpoch,
        # return activities from after this date. PowerShell DateTime object.
        [Parameter(Position = 3)]
        [DateTime]$after,
        # return activities from after this date. Unix Epoch time.
        [Parameter(Position = 3)]
        [Int]$afterUnixEpoch,
        # return activities older than this activity id.
        [Parameter(Position = 4)]
        [Int]$olderThan,
        # return activities newer than this activity id.
        [Parameter(Position = 5)]
        [Int]$newerThan,
        # return activities of this type.
        [Parameter(Position = 6)]
        [String]$type,
        # return activities of this type.
        [Parameter(Position = 6)]
        [String]$activityType,
        # return activities with this status.
        [Parameter(Position = 7)]
        [String]$status,
        # return activities for this user.
        [Parameter(Position = 8)]
        [String]$user,
        # return activities for this alert series.
        [Parameter(Position = 9)]
        [String]$seriesUid,
        # return activities matching this device filter.
        [Parameter(Position = 10)]
        [Alias('df')]
        [String]$deviceFilter,
        # Number of results per page.
        [Parameter(Position = 11)]
        [Int]$pageSize,
        # Filter by language tag.
        [Parameter(Position = 12)]
        [Alias('lang')]
        [String]$languageTag,
        # Filter by timezone.
        [Parameter(Position = 13)]
        [Alias('tz')]
        [String]$timeZone,
        # return the activities object instead of the default return with `lastActivityId` and `activities` properties.
        [Switch]$expandActivities
    )
    $CommandName = $MyInvocation.InvocationName
    $Parameters = (Get-Command -Name $CommandName).Parameters
    # Workaround to prevent the query string processor from adding an 'deviceid=' parameter by removing it from the set parameters.
    if ($deviceId) {
        $Parameters.Remove('deviceId')
        if ($type) {
            $Parameters.Remove('type')
            [string]$activityType = $type
        }
    } else {
        if ($activityType) {
            $Parameters.Remove('activityType')
            [string]$type = $activityType
        }
    }
    # If the [DateTime] parameter $before is set convert the value to a Unix Epoch.
    if ($before) {
        [Int]$before = ConvertTo-UnixEpoch -DateTime $before
    }
    # If the Unix Epoch parameter $beforeUnixEpoch is set assign the value to the $before variable and null $beforeUnixEpoch.
    if ($beforeUnixEpoch) {
        $Parameters.Remove('beforeUnixEpoch') | Out-Null
        [Int]$before = $beforeUnixEpoch
    }
    # If the [DateTime] parameter $after is set convert the value to a Unix Epoch.
    if ($after) {
        [Int]$after = ConvertTo-UnixEpoch -DateTime $after
    }
    # If the Unix Epoch parameter $afterUnixEpoch is set assign the value to the $after variable and null $afterUnixEpoch.
    if ($afterUnixEpoch) {
        $Parameters.Remove('afterUnixEpoch') | Out-Null
        [Int]$after = $afterUnixEpoch
    }
    try {
        $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
        if ($deviceId) {
            Write-Verbose 'Getting device from NinjaOne API.'
            $Device = Get-NinjaOneDevices -deviceId $deviceId
            if ($Device) {
                Write-Verbose ('Getting activities for device {0}.' -f $Device.SystemName)
                $Resource = ('v2/device/{0}/activities' -f $deviceId)
            } else {
                throw ('Device with id {0} not found.' -f $deviceId)
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
        if ($ActivityResults) {
            if ($expandActivities) {
                return $ActivityResults.activities
            } else {
                return $ActivityResults
            }
        } else {
            if ($Device) {
                throw ('No activities found for device {0}.' -f $Device.SystemName)
            } else {
                throw 'No activities found.'
            }
        }
    } catch {
        New-NinjaOneError -ErrorRecord $_
    }
}