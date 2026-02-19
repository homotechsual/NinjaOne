---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/locationcustomfields
schema: 2.0.0
---

# Get-NinjaOneLocationCustomFields

## SYNOPSIS
Gets location custom fields from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneLocationCustomFields [-organisationId] <Int32> [-locationId] <Int32> [[-withInheritance] <Boolean>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves location custom fields from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneLocationCustomFields organisationId 1 -locationId 2
```

Gets custom field details for the location with id 2 belonging to the organisation with id 1.

### EXAMPLE 2
```
Get-NinjaOneLocationCustomFields organisationId 1 -locationId 2 -withInheritance
```

Gets custom field details for the location with id 2 belonging to the organisation with id 1 and inherits values from parent organisation, if no value is set for the location you will get the value from the parent organisation.

## PARAMETERS

### -organisationId
Filter by organisation id.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: id, organizationId

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -locationId
Filter by location id.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -withInheritance
Inherit custom field values from parent organisation.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: False
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/locationcustomfields](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/locationcustomfields)

