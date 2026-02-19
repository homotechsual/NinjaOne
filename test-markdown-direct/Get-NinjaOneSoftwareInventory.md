---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/softwareinventoryquery
schema: 2.0.0
---

# Get-NinjaOneSoftwareInventory

## SYNOPSIS
Gets the software inventory from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneSoftwareInventory [[-deviceFilter] <String>] [[-cursor] <String>] [[-pageSize] <Int32>]
 [[-installedBefore] <DateTime>] [[-installedBeforeUnixEpoch] <Int32>] [[-installedAfter] <DateTime>]
 [[-installedAfterUnixEpoch] <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves the software inventory from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneSoftwareInventory
```

Gets the software inventory.

### EXAMPLE 2
```
Get-NinjaOneSoftwareInventory -deviceFilter 'org = 1'
```

Gets the software inventory for the organisation with id 1.

### EXAMPLE 3
```
Get-NinjaOneSoftwareInventory -installedBefore (Get-Date)
```

Gets the software inventory for software installed before the current date.

### EXAMPLE 4
```
Get-NinjaOneSoftwareInventory -installedBeforeUnixEpoch 1619712000
```

Gets the software inventory for software installed before 1619712000.

### EXAMPLE 5
```
Get-NinjaOneSoftwareInventory -installedAfter (Get-Date).AddDays(-1)
```

Gets the software inventory for software installed after the previous day.

### EXAMPLE 6
```
Get-NinjaOneSoftwareInventory -installedAfterUnixEpoch 1619712000
```

Gets the software inventory for software installed after 1619712000.

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

### -installedBefore
Filter software to those installed before this date.
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

### -installedBeforeUnixEpoch
Filter software to those installed after this date.
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

### -installedAfter
Filter software to those installed after this date.
PowerShell DateTime object.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -installedAfterUnixEpoch
Filter software to those installed after this date.
Unix Epoch time.

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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/softwareinventoryquery](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/softwareinventoryquery)

