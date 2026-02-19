---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/locations
schema: 2.0.0
---

# Get-NinjaOneLocations

## SYNOPSIS
Gets locations from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneLocations [[-pageSize] <Int32>] [[-after] <Int32>] [[-organisationId] <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves locations from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneLocations
```

Gets all locations.

### EXAMPLE 2
```
Get-NinjaOneLocations -after 1
```

Gets all locations after location id 1.

### EXAMPLE 3
```
Get-NinjaOneLocations -organisationId 1
```

Gets all locations for the organisation with id 1.

## PARAMETERS

### -pageSize
Number of results per page.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -after
Start results from location id.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -organisationId
Filter by organisation id.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: id, organizationId

Required: False
Position: 3
Default value: 0
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

### A powershell object containing the response.
## NOTES

## RELATED LINKS

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/locations](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/locations)

