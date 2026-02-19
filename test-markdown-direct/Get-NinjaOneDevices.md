---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devices
schema: 2.0.0
---

# Get-NinjaOneDevices

## SYNOPSIS
Gets devices from the NinjaOne API.

## SYNTAX

### Multi (Default)
```
Get-NinjaOneDevices [[-deviceFilter] <String>] [[-pageSize] <Int32>] [[-after] <Int32>] [-detailed]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Single
```
Get-NinjaOneDevices [-deviceId] <Int32> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Organisation
```
Get-NinjaOneDevices [[-pageSize] <Int32>] [[-after] <Int32>] [-organisationId] <Int32>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves devices from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneDevices
```

Gets all devices.

### EXAMPLE 2
```
Get-NinjaOneDevices -deviceId 1
```

Gets the device with id 1.

### EXAMPLE 3
```
Get-NinjaOneDevices -organisationId 1
```

Gets all devices for the organisation with id 1.

### EXAMPLE 4
```
Get-NinjaOneDevices -deviceFilter 'status eq APPROVED'
```

Gets all approved devices.

### EXAMPLE 5
```
Get-NinjaOneDevices -deviceFilter 'class in (WINDOWS_WORKSTATION,MAC,LINUX_WORKSTATION)'
```

Gets all WINDOWS_WORKSTATION, MAC or LINUX_WORKSTATION devices.

### EXAMPLE 6
```
Get-NinjaOneDevices -deviceFilter 'class eq WINDOWS_WORKSTATION AND online'
```

Gets all online WINDOWS_WORKSTATION devices.

## PARAMETERS

### -deviceId
Device id to retrieve

```yaml
Type: Int32
Parameter Sets: Single
Aliases: id

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -deviceFilter
Filter devices.

```yaml
Type: String
Parameter Sets: Multi
Aliases: df

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -pageSize
Number of results per page.

```yaml
Type: Int32
Parameter Sets: Multi, Organisation
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -after
Start results from device id.

```yaml
Type: Int32
Parameter Sets: Multi, Organisation
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -detailed
Include locations and policy mappings.

```yaml
Type: SwitchParameter
Parameter Sets: Multi
Aliases:

Required: False
Position: 5
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -organisationId
Filter by organisation id.

```yaml
Type: Int32
Parameter Sets: Organisation
Aliases: organizationId

Required: True
Position: 1
Default value: 0
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devices](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devices)

