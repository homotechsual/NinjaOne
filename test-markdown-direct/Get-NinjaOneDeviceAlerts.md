---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicealerts
schema: 2.0.0
---

# Get-NinjaOneDeviceAlerts

## SYNOPSIS
Wrapper command using \`Get-NinjaOneAlerts\` to get alerts for a device.

## SYNTAX

```
Get-NinjaOneDeviceAlerts [-deviceId] <Int32> [[-languageTag] <String>] [[-timezone] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Gets alerts for a device using the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneDeviceAlerts -deviceId 1
```

Gets alerts for the device with id 1.

## PARAMETERS

### -deviceId
Filter by device id.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: id

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -languageTag
Return built in condition names in the given language.

```yaml
Type: String
Parameter Sets: (All)
Aliases: lang

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -timezone
Return alert times/dates in the given timezone.

```yaml
Type: String
Parameter Sets: (All)
Aliases: tz

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicealerts](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicealerts)

