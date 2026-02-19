---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicehealthquery
schema: 2.0.0
---

# Get-NinjaOneDeviceHealth

## SYNOPSIS
Gets the device health from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneDeviceHealth [[-deviceFilter] <String>] [[-health] <String>] [[-cursor] <String>]
 [[-pageSize] <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves the device health from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneDeviceHealth
```

Gets the device health.

### EXAMPLE 2
```
Get-NinjaOneDeviceHealth -deviceFilter 'org = 1'
```

Gets the device health for the organisation with id 1.

### EXAMPLE 3
```
Get-NinjaOneDeviceHealth -health 'UNHEALTHY'
```

Gets the device health for devices with the health status 'UNHEALTHY'.

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

### -health
Filter by health status.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicehealthquery](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicehealthquery)

