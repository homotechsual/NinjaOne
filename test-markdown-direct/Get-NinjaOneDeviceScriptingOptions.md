---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicescriptingoptions
schema: 2.0.0
---

# Get-NinjaOneDeviceScriptingOptions

## SYNOPSIS
Gets device scripting options from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneDeviceScriptingOptions [-deviceId] <Int32> [[-LanguageTag] <String>] [-Categories] [-Scripts]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves device scripting options from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneDeviceScriptingOptions -deviceId 1
```

Gets the device scripting options for the device with id 1.

### EXAMPLE 2
```
Get-NinjaOneDeviceScriptingOptions -deviceId 1 -Scripts
```

Gets the scripts for the device with id 1.

### EXAMPLE 3
```
Get-NinjaOneDeviceScriptingOptions -deviceId 1 -Categories
```

Gets the categories for the device with id 1.

## PARAMETERS

### -deviceId
The device id to get the scripting options for.

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

### -LanguageTag
Built in scripts / job names should be returned in the specified language.

```yaml
Type: String
Parameter Sets: (All)
Aliases: lang

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Categories
Return the categories list only.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Scripts
Return the scripts list only.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicescriptingoptions](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicescriptingoptions)

