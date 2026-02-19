---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/jobs/
schema: 2.0.0
---

# Get-NinjaOneJobs

## SYNOPSIS
Gets jobs from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneJobs [[-deviceId] <Int32>] [[-jobType] <String>] [[-deviceFilter] <String>]
 [[-languageTag] <String>] [[-timeZone] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves jobs from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneJobs
```

Gets all jobs.

### EXAMPLE 2
```
Get-NinjaOneJobs -jobType SOFTWARE_PATCH_MANAGEMENT
```

Gets software patch management jobs.

### EXAMPLE 3
```
Get-NinjaOneJobs -deviceFilter 'organization in (1,2,3)'
```

Gets jobs for devices in organisations 1, 2 and 3.

### EXAMPLE 4
```
Get-NinjaOneJobs -deviceId 1
```

Gets jobs for the device with id 1.

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

### -jobType
Filter by job type.

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

### -deviceFilter
Filter by device triggering the alert.

```yaml
Type: String
Parameter Sets: (All)
Aliases: df

Required: False
Position: 3
Default value: None
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
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -timeZone
Filter by timezone.

```yaml
Type: String
Parameter Sets: (All)
Aliases: ts

Required: False
Position: 5
Default value: None
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/jobs/](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/jobs/)

