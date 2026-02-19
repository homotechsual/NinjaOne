---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicevolumes
schema: 2.0.0
---

# Get-NinjaOneDeviceVolumes

## SYNOPSIS
Gets device volumes from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneDeviceVolumes [-deviceId] <Int32> [[-include] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Retrieves device volumes from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneDeviceVolumes -deviceId 1
```

Gets the volumes for the device with id 1.

### EXAMPLE 2
```
Get-NinjaOneDeviceVolumes -deviceId 1 -include bl
```

Gets the volumes for the device with id 1 and includes BitLocker status.

## PARAMETERS

### -deviceId
Device id to get volumes for.

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

### -include
Additional information to include currently known options are 'bl' for BitLocker status.

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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicevolumes](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicevolumes)

