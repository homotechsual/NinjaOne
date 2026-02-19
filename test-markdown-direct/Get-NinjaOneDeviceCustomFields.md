---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/contacts
schema: 2.0.0
---

# Get-NinjaOneDeviceCustomFields

## SYNOPSIS
Gets device custom fields from the NinjaOne API.

## SYNTAX

### Single
```
Get-NinjaOneDeviceCustomFields [-deviceId] <Int32> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Multi
```
Get-NinjaOneDeviceCustomFields [[-scope] <String[]>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves device custom fields from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneDeviceCustomFields
```

Gets all device custom fields.

### EXAMPLE 2
```
Get-NinjaOneDeviceCustomFields | Group-Object { $_.scope }
```

Gets all device custom fields grouped by the scope property.

### EXAMPLE 3
```
Get-NinjaOneDeviceCustomFields -deviceId 1
```

Gets the device custom fields and values for the device with id 1

### EXAMPLE 4
```
Get-NinjaOneDeviceCustomFields -deviceId 1 -withInheritance
```

Gets the device custom fields and values for the device with id 1 and inherits values from parent location and/or organisation, if no value is set for the device you will get the value from the parent location and if no value is set for the parent location you will get the value from the parent organisation.

## PARAMETERS

### -deviceId
Device id to get custom field values for a specific device.

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

### -scope
The scopes to get custom field definitions for.

```yaml
Type: String[]
Parameter Sets: Multi
Aliases:

Required: False
Position: 1
Default value: All
Accept pipeline input: True (ByPropertyName, ByValue)
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

### A powershell object containing the response
## NOTES

## RELATED LINKS

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/contacts](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/contacts)

