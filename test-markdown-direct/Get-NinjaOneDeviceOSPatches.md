---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/deviceospatches
schema: 2.0.0
---

# Get-NinjaOneDeviceOSPatches

## SYNOPSIS
Gets device OS patches from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneDeviceOSPatches [-deviceId] <Int32> [[-status] <String[]>] [[-type] <String[]>]
 [[-severity] <String[]>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves device OS patches from the NinjaOne v2 API.
If you want patch information for multiple devices please check out the related 'queries' commandlet \`Get-NinjaOneOSPatches\`.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneDeviceOSPatches -deviceId 1
```

Gets OS patch information for the device with id 1.

### EXAMPLE 2
```
Get-NinjaOneDeviceOSPatches -deviceId 1 -status 'APPROVED' -type 'SECURITY_UPDATES' -severity 'CRITICAL'
```

Gets OS patch information for the device with id 1 where the patch is an approved security update with critical severity.

## PARAMETERS

### -deviceId
Device id to get OS patch information for.

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
Filter returned patches by patch status.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -type
Filter returned patches by type.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -severity
Filter returned patches by severity.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/deviceospatches](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/deviceospatches)

