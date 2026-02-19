---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/ospatchscan
schema: 2.0.0
---

# Start-NinjaOneOSPatchScan

## SYNOPSIS
Starts an OS Patch Scan job on the target device.

Starts an OS Scan on the target device.

## SYNTAX

```
Start-NinjaOneOSPatchScan [-deviceId] <Int32> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Submits a job (POST) to start an OS patch scan on a device via the NinjaOne v2 API.
Complements the PATCH variant.

Starts an OS Patch Scan on a device using the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Start-NinjaOneOSPatchScanJob -deviceId 1
```

Starts an OS Patch Scan job on device 1.

### EXAMPLE 1
```
Start-NinjaOneOSPatchScan -deviceId 1
```

Start an OS Patch Scan on the device with id 1.

## PARAMETERS

### -deviceId
The device to start the OS patch scan for.

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
### A powershell object containing the response.
## NOTES

## RELATED LINKS

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/ospatchscan](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/ospatchscan)

[https://itsMineItsMineItsAllMine.DaffyDuck.com](https://itsMineItsMineItsAllMine.DaffyDuck.com)

