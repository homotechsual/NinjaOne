---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Find/devices
schema: 2.0.0
---

# Find-NinjaOneDevices

## SYNOPSIS
Searches for devices from the NinjaOne API.

## SYNTAX

```
Find-NinjaOneDevices [-limit <Int32>] [-searchQuery] <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Retrieves devices from the NinjaOne v2 API matching a search string.

## EXAMPLES

### EXAMPLE 1
```
Find-NinjaOneDevices -limit 10 -searchQuery 'ABCD'
```

returns an object containing the query and matching devices.
Raw data return

### EXAMPLE 2
```
(Find-NinjaOneDevices -limit 10 -searchQuery 'ABCD').devices
```

returns an array of device objects matching the query.

## PARAMETERS

### -limit
Limit number of devices to return.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -searchQuery
Search query

```yaml
Type: String
Parameter Sets: (All)
Aliases: q

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Find/devices](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Find/devices)

