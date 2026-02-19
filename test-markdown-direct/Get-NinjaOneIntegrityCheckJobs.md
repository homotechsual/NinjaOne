---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/integritycheckjobs
schema: 2.0.0
---

# Get-NinjaOneIntegrityCheckJobs

## SYNOPSIS
Gets backup integrity check jobs from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneIntegrityCheckJobs [[-cursor] <String>] [[-deletedDeviceFilter] <String>]
 [[-deviceFilter] <String>] [[-include] <String>] [[-pageSize] <Int32>] [[-planType] <String>]
 [[-planTypeFilter] <String>] [[-status] <String>] [[-statusFilter] <String>]
 [[-startTimeBetween] <DateTime[]>] [[-startTimeAfter] <DateTime>] [[-startTimeFilter] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves backup integrity check jobs from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneIntegrityCheckJobs
```

Gets all backup integrity check jobs.

### EXAMPLE 2
```
Get-NinjaOneIntegrityCheckJobs -status 'RUNNING'
```

Gets all backup integrity check jobs with a status of 'RUNNING'.

### EXAMPLE 3
```
Get-NinjaOneIntegrityCheckJobs -status 'RUNNING', 'COMPLETED'
```

Gets all backup integrity check jobs with a status of 'RUNNING' or 'COMPLETED'.

### EXAMPLE 4
```
Get-NinjaOneIntegrityCheckJobs -statusFilter 'status = RUNNING'
```

Gets all backup integrity check jobs with a status of 'RUNNING'.

### EXAMPLE 5
```
Get-NinjaOneIntegrityCheckJobs -statusFilter 'status in (RUNNING, COMPLETED)'
```

Gets all backup integrity check jobs with a status of 'RUNNING' or 'COMPLETED'.

### EXAMPLE 6
```
Get-NinjaOneIntegrityCheckJobs -planType 'IMAGE'
```

Gets all backup integrity check jobs with a plan type of 'IMAGE'.

### EXAMPLE 7
```
Get-NinjaOneIntegrityCheckJobs -planType 'IMAGE', 'FILE_FOLDER'
```

Gets all backup integrity check jobs with a plan type of 'IMAGE' or 'FILE_FOLDER'.

### EXAMPLE 8
```
Get-NinjaOneIntegrityCheckJobs -planTypeFilter 'planType = IMAGE'
```

Gets all backup integrity check jobs with a plan type of 'IMAGE'.

### EXAMPLE 9
```
Get-NinjaOneIntegrityCheckJobs -planTypeFilter 'planType in (IMAGE, FILE_FOLDER)'
```

Gets all backup integrity check jobs with a plan type of 'IMAGE' or 'FILE_FOLDER'.

### EXAMPLE 10
```
Get-NinjaOneIntegrityCheckJobs -startTimeBetween (Get-Date).AddDays(-1), (Get-Date)
```

Gets all backup integrity check jobs with a start time between 24 hours ago and now.

### EXAMPLE 11
```
Get-NinjaOneIntegrityCheckJobs -startTimeAfter (Get-Date).AddDays(-1)
```

Gets all backup integrity check jobs with a start time after 24 hours ago.

### EXAMPLE 12
```
Get-NinjaOneIntegrityCheckJobs -startTimeFilter 'startTime between(2024-01-01T00:00:00.000Z,2024-01-02T00:00:00.000Z)'
```

Gets all backup integrity check jobs with a start time between 2024-01-01T00:00:00.000Z and 2024-01-02T00:00:00.000Z.

### EXAMPLE 13
```
Get-NinjaOneIntegrityCheckJobs -startTimeFilter 'startTime after 2024-01-01T00:00:00.000Z'
```

Gets all backup integrity check jobs with a start time after 2024-01-01T00:00:00.000Z.

### EXAMPLE 14
```
Get-NinjaOneIntegrityCheckJobs -deviceFilter all
```

Gets all backup integrity check jobs for the all devices.
Includes active and deleted devices.

## PARAMETERS

### -cursor
Cursor name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -deletedDeviceFilter
Deleted device filter.

```yaml
Type: String
Parameter Sets: (All)
Aliases: ddf

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -deviceFilter
Device filter.

```yaml
Type: String
Parameter Sets: (All)
Aliases: df

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -include
Which devices to include (defaults to 'active').

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -pageSize
Number of results per page.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -planType
Filter by plan type.
See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/ptf

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -planTypeFilter
Raw plan type filter.
See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/ptf

```yaml
Type: String
Parameter Sets: (All)
Aliases: ptf

Required: False
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -status
Filter by status.
See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/sf

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -statusFilter
Raw status filter.
See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/sf

```yaml
Type: String
Parameter Sets: (All)
Aliases: sf

Required: False
Position: 8
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -startTimeBetween
Start time between filter.
See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/stf

```yaml
Type: DateTime[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -startTimeAfter
Start time after filter.
See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/stf

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -startTimeFilter
Raw start time filter.
See the supplemental documentation at https://docs.homotechsual.dev/modules/ninjaone/filters/stf

```yaml
Type: String
Parameter Sets: (All)
Aliases: stf

Required: False
Position: 11
Default value: None
Accept pipeline input: True (ByPropertyName)
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/integritycheckjobs](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/integritycheckjobs)

