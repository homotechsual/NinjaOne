---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicesoftwarepatchinstalls
schema: 2.0.0
---

# Get-NinjaOneDeviceSoftwarePatchInstalls

## SYNOPSIS
Gets device software patch installs from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneDeviceSoftwarePatchInstalls [-deviceId] <Int32> [[-type] <String>] [[-impact] <String>]
 [[-status] <String>] [[-productIdentifier] <String>] [[-installedBefore] <DateTime>]
 [[-installedBeforeUnixEpoch] <Int32>] [[-installedAfter] <DateTime>] [[-installedAfterUnixEpoch] <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves device software patch installs from the NinjaOne v2 API.
If you want patch install status for multiple devices please check out the related 'queries' commandlet \`Get-NinjaOneSoftwarePatchInstalls\`.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneDeviceSoftwarePatchInstalls -deviceId 1
```

Gets software patch installs for the device with id 1.

### EXAMPLE 2
```
Get-NinjaOneDeviceSoftwarePatchInstalls -deviceId 1 -type 'PATCH' -impact 'RECOMMENDED' -status 'FAILED' -installedAfter (Get-Date 2022/01/01)
```

Gets OS patch installs for the device with id 1 where the patch with type patch and impact / severity recommended failed to install after 2022-01-01.

## PARAMETERS

### -deviceId
Device id to get software patch install information for.

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

### -type
Filter patches by type.

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

### -impact
Filter patches by impact.

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

### -status
Filter patches by patch status.

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

### -productIdentifier
Filter patches by product identifier.

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

### -installedBefore
Filter patches to those installed before this date.
PowerShell DateTime object.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -installedBeforeUnixEpoch
Filter patches to those installed after this date.
Unix Epoch time.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -installedAfter
Filter patches to those installed after this date.
PowerShell DateTime object.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -installedAfterUnixEpoch
Filter patches to those installed after this date.
Unix Epoch time.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 0
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicesoftwarepatchinstalls](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicesoftwarepatchinstalls)

