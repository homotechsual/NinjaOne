---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/activities
schema: 2.0.0
---

# Get-NinjaOneActivities

## SYNOPSIS
Gets activities from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneActivities [[-deviceId] <Int32>] [[-class] <String>] [[-before] <DateTime>]
 [[-beforeUnixEpoch] <Int32>] [[-after] <DateTime>] [[-afterUnixEpoch] <Int32>] [[-olderThan] <Int32>]
 [[-newerThan] <Int32>] [[-type] <String>] [[-activityType] <String>] [[-status] <String>] [[-user] <String>]
 [[-seriesUid] <String>] [[-deviceFilter] <String>] [[-pageSize] <Int32>] [[-languageTag] <String>]
 [[-timeZone] <String>] [[-sourceConfigUid] <String>] [-expandActivities] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Retrieves activities from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneActivities
```

Gets all activities.

### EXAMPLE 2
```
Get-NinjaOneActivities -deviceId 1
```

Gets activities for the device with id 1.

### EXAMPLE 3
```
Get-NinjaOneActivities -class SYSTEM
```

Gets system activities.

### EXAMPLE 4
```
Get-NinjaOneActivities -before ([DateTime]::Now.AddDays(-1))
```

Gets activities from before yesterday.

### EXAMPLE 5
```
Get-NinjaOneActivities -after ([DateTime]::Now.AddDays(-1))
```

Gets activities from after yesterday.

### EXAMPLE 6
```
Get-NinjaOneActivities -olderThan 1
```

Gets activities older than activity id 1.

### EXAMPLE 7
```
Get-NinjaOneActivities -newerThan 1
```

Gets activities newer than activity id 1.

### EXAMPLE 8
```
Get-NinjaOneActivities -type 'Action'
```

Gets activities of type 'Action'.

### EXAMPLE 9
```
Get-NinjaOneActivities -status 'COMPLETED'
```

Gets activities with status 'COMPLETED'.

### EXAMPLE 10
```
Get-NinjaOneActivities -seriesUid '23e4567-e89b-12d3-a456-426614174000'
```

Gets activities for the alert series with uid '23e4567-e89b-12d3-a456-426614174000'.

### EXAMPLE 11
```
Get-NinjaOneActivities -deviceFilter 'organization in (1,2,3)'
```

Gets activities for devices in organisations 1, 2 and 3.

## PARAMETERS

### -deviceId
Filter by device id.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: id

Required: False
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -class
Activity class.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -before
return activities from before this date.
PowerShell DateTime object.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -beforeUnixEpoch
return activities from before this date.
Unix Epoch time.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -after
return activities from after this date.
PowerShell DateTime object.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -afterUnixEpoch
return activities from after this date.
Unix Epoch time.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -olderThan
return activities older than this activity id.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -newerThan
return activities newer than this activity id.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -type
return activities of this type.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -activityType
return activities of this type.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -status
return activities with this status.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -user
return activities for this user.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -seriesUid
return activities for this alert series.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -deviceFilter
return activities matching this device filter.

```yaml
Type: String
Parameter Sets: (All)
Aliases: df

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -pageSize
Number of results per page.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -languageTag
Filter by language tag.

```yaml
Type: String
Parameter Sets: (All)
Aliases: lang

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -timeZone
Filter by timezone.

```yaml
Type: String
Parameter Sets: (All)
Aliases: tz

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -sourceConfigUid
return activities for this source configuration.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -expandActivities
return the activities object instead of the default return with \`lastActivityId\` and \`activities\` properties.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### A powershell object containing the response.
## NOTES

## RELATED LINKS

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/activities](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/activities)

