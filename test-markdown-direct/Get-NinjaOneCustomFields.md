---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/customfieldsquery
schema: 2.0.0
---

# Get-NinjaOneCustomFields

## SYNOPSIS
Gets the custom fields from the NinjaOne API.

## SYNTAX

### Default (Default)
```
Get-NinjaOneCustomFields [[-deviceFilter] <String>] [[-cursor] <String>] [[-pageSize] <Int32>]
 [[-updatedAfter] <DateTime>] [[-updatedAfterUnixEpoch] <Int64>] [[-fields] <String[]>] [-detailed]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Scoped
```
Get-NinjaOneCustomFields [[-cursor] <String>] [[-pageSize] <Int32>] [[-scopes] <String[]>]
 [[-updatedAfter] <DateTime>] [[-updatedAfterUnixEpoch] <Int64>] [[-fields] <String[]>] [-detailed]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves the custom fields from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneCustomFields
```

Gets all custom field values for all devices.

### EXAMPLE 2
```
Get-NinjaOneCustomFields -deviceFilter 'org = 1'
```

Gets all custom field values for all devices in the organisation with id 1.

### EXAMPLE 3
```
Get-NinjaOneCustomFields -updatedAfter (Get-Date).AddDays(-1)
```

Gets all custom field values for all devices updated in the last 24 hours.

### EXAMPLE 4
```
Get-NinjaOneCustomFields -updatedAfterUnixEpoch 1619712000000
```

Gets all custom field values for all devices updated at or after Thu Apr 29 2021 16:00.

### EXAMPLE 5
```
Get-NinjaOneCustomFields -fields 'hasBatteries', 'autopilotHwid'
```

Gets the custom field values for the specified fields.

### EXAMPLE 6
```
Get-NinjaOneCustomFields -detailed
```

Gets the detailed version of the custom field values.

## PARAMETERS

### -deviceFilter
Filter devices.

```yaml
Type: String
Parameter Sets: Default
Aliases: df

Required: False
Position: 1
Default value: None
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
Position: 2
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
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -scopes
Custom field scopes to filter by.

```yaml
Type: String[]
Parameter Sets: Scoped
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -updatedAfter
Custom fields updated after the specified date.
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

### -updatedAfterUnixEpoch
Custom fields updated after the specified date.
Unix Epoch time (milliseconds).

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -fields
Array of fields.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -detailed
Get the detailed custom fields report(s).

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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/customfieldsquery](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/customfieldsquery)

