---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/computersystemsquery
schema: 2.0.0
---

# Get-NinjaOneComputerSystems

## SYNOPSIS
Gets the computer systems from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneComputerSystems [[-deviceFilter] <String>] [[-timeStamp] <DateTime>]
 [[-timeStampUnixEpoch] <Int32>] [[-cursor] <String>] [[-pageSize] <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves the computer systems from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneComputerSystems
```

Gets all computer systems.

### EXAMPLE 2
```
Get-NinjaOneComputerSystems -deviceFilter 'org = 1'
```

Gets the computer systems for the organisation with id 1.

### EXAMPLE 3
```
Get-NinjaOneComputerSystems -timeStamp 1619712000
```

Gets the computer systems with a monitoring timestamp at or after 1619712000.

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
Monitoring timestamp filter in unix time.

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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/computersystemsquery](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/computersystemsquery)

