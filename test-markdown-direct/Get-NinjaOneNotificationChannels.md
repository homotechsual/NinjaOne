---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/notificationchannels
schema: 2.0.0
---

# Get-NinjaOneNotificationChannels

## SYNOPSIS
Gets notification channels from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneNotificationChannels [-enabled] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves notification channel details from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneNotificationChannels
```

Gets all notification channels.

### EXAMPLE 2
```
Get-NinjaOneNotificationChannels -enabled
```

Gets all enabled notification channels.

## PARAMETERS

### -enabled
Get all enabled notification channels.

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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/notificationchannels](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/notificationchannels)

