---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/scriptoraction
schema: 2.0.0
---

# Invoke-NinjaOneDeviceScript

## SYNOPSIS
Runs a script or built-in action against the given device.

## SYNTAX

### ACTION
```
Invoke-NinjaOneDeviceScript [-deviceId] <Int32> [-type] <String> [-actionUId] <Guid> [[-parameters] <String>]
 [[-runAs] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### SCRIPT
```
Invoke-NinjaOneDeviceScript [-deviceId] <Int32> [-type] <String> [-scriptId] <Int32> [[-parameters] <String>]
 [[-runAs] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Runs a script or built-in action against a single device using the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Invoke-NinjaOneDeviceScript -deviceId 1 -type 'SCRIPT' -scriptId 1
```

Runs the script with id 1 against the device with id 1.

### EXAMPLE 2
```
Invoke-NinjaOneDeviceScript -deviceId 1 -type 'ACTION' -actionUId '00000000-0000-0000-0000-000000000000'
```

Runs the built-in action with uid 00000000-0000-0000-0000-000000000000 against the device with id 1.

### EXAMPLE 3
```

```

## PARAMETERS

### -deviceId
The device to run a script on.

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
The type - script or action.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -scriptId
The id of the script to run.
Only used if the type is script.

```yaml
Type: Int32
Parameter Sets: SCRIPT
Aliases:

Required: True
Position: 3
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -actionUId
The unique uid of the action to run.
Only used if the type is action.

```yaml
Type: Guid
Parameter Sets: ACTION
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -parameters
The parameters to pass to the script or action.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -runAs
The credential/role identifier to use when running the script.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/scriptoraction](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/scriptoraction)

