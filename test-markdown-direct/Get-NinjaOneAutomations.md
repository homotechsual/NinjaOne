---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/automationscripts
schema: 2.0.0
---

# Get-NinjaOneAutomations

## SYNOPSIS
Gets automation scripts from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneAutomations [[-languageTag] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves automation scripts from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneAutomations
```

Gets all automation scripts.

### EXAMPLE 2
```
Get-NinjaOneAlerts -lang 'en'
```

Gets all automation scripts, returning the name of built in automation scripts in English.

## PARAMETERS

### -languageTag
Return built in automation script names in the given language.

```yaml
Type: String
Parameter Sets: (All)
Aliases: lang

Required: False
Position: 1
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/automationscripts](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/automationscripts)

