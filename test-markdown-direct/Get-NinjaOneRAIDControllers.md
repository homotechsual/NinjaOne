---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/raidcontrollersquery
schema: 2.0.0
---

# Get-NinjaOneRAIDControllers

## SYNOPSIS
Gets the RAID controllers from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneRAIDControllers [[-deviceFilter] <String>] [[-timeStamp] <DateTime>]
 [[-timeStampUnixEpoch] <Int32>] [[-cursor] <String>] [[-pageSize] <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves the RAID controllers from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneRAIDControllers
```

Gets the RAID controllers.

### EXAMPLE 2
```
Get-NinjaOneRAIDControllers -deviceFilter 'org = 1'
```

Gets the RAID controllers for the organisation with id 1.

### EXAMPLE 3
```
Get-NinjaOneRAIDControllers -timeStamp 1619712000
```

Gets the RAID controllers with a monitoring timestamp at or after 1619712000.

## PARAMETERS

### -deviceFilter
Filter devices.

```yaml
Type: String
Parameter Sets: (All)
Aliases: df

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -timeStamp
Monitoring timestamp filter.
PowerShell DateTime object.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases: ts

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -timeStampUnixEpoch
Monitoring timestamp filter.
Unix Epoch time.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -cursor
Cursor name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
Position: 4
Default value: 0
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/raidcontrollersquery](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/raidcontrollersquery)

