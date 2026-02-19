---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/alerts
schema: 2.0.0
---

# Get-NinjaOneAlerts

## SYNOPSIS
Gets alerts from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneAlerts [[-deviceId] <Int32>] [[-sourceType] <String>] [[-deviceFilter] <String>]
 [[-languageTag] <String>] [[-timeZone] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves alerts from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneAlerts
```

Gets all alerts.

### EXAMPLE 2
```
Get-NinjaOneAlerts -sourceType 'CONDITION_CUSTOM_FIELD'
```

Gets all alerts with source type CONDITION_CUSTOM_FIELD.

### EXAMPLE 3
```
Get-NinjaOneAlerts -deviceFilter 'status eq APPROVED'
```

Gets alerts for all approved devices.

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

### -sourceType
Filter by source type.

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
Filter by device which triggered the alert.

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
Aliases: tz

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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/alerts](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/alerts)

