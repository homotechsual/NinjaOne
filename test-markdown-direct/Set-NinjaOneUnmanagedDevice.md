---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/unmanageddevice
schema: 2.0.0
---

# Set-NinjaOneUnmanagedDevice

## SYNOPSIS
Updates an unmanaged device.

## SYNTAX

```
Set-NinjaOneUnmanagedDevice [-nodeId] <Int32> [-unmanagedDevice] <Object> [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates an unmanaged device via the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Set-NinjaOneUnmanagedDevice -nodeId 5001 -unmanagedDevice @{ hostname = 'asset-5001' }
```

Updates unmanaged device 5001.

## PARAMETERS

### -nodeId
Unmanaged device node Id

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -unmanagedDevice
Update payload

```yaml
Type: Object
Parameter Sets: (All)
Aliases: body

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### Status code or updated resource per API.
## NOTES

## RELATED LINKS

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/unmanageddevice](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/unmanageddevice)

