---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicesoftwarepatches
schema: 2.0.0
---

# Get-NinjaOneDeviceSoftwarePatches

## SYNOPSIS
Gets device Software patches from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneDeviceSoftwarePatches [-deviceId] <Int32> [[-status] <String>] [[-productIdentifier] <String>]
 [[-type] <String>] [[-impact] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves device Software patches from the NinjaOne v2 API.
If you want patch information for multiple devices please check out the related 'queries' commandlet \`Get-NinjaOneSoftwarePatches\`.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneDeviceSoftwarePatches -deviceId 1
```

Gets all software patches for the device with id 1.

### EXAMPLE 2
```
Get-NinjaOneDeviceSoftwarePatches -deviceId 1 -status 'APPROVED' -type 'PATCH' -impact 'CRITICAL'
```

Gets all software patches for the device with id 1 where the patch is approved, has type patch and has critical impact/severity.

## PARAMETERS

### -deviceId
Device id to get software patch information for.

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

### -status
Filter patches by patch status.

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

### -productIdentifier
Filter patches by product identifier.

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

### -type
Filter patches by type.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -impact
Filter patches by impact.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicesoftwarepatches](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicesoftwarepatches)

