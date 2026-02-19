---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/softwarepatchapply
schema: 2.0.0
---

# Start-NinjaOneSoftwarePatchApply

## SYNOPSIS
Starts a Software Patch Apply on the target device.

## SYNTAX

```
Start-NinjaOneSoftwarePatchApply [-deviceId] <Int32> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Submits a job to start a software patch apply on a device via the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Start-NinjaOneSoftwarePatchApply -deviceId 1
```

Start a Software Patch Apply on the device with id 1.

## PARAMETERS

### -deviceId
The device to start the software patch apply for.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
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

### A PowerShell object containing the response.
## NOTES

## RELATED LINKS

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/softwarepatchapply](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/softwarepatchapply)

