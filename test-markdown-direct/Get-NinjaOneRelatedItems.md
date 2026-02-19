---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/relateditems
schema: 2.0.0
---

# Get-NinjaOneRelatedItems

## SYNOPSIS
Gets items related to an entity or entity type from the NinjaOne API.

## SYNTAX

### all
```
Get-NinjaOneRelatedItems [-all] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### relatedTo
```
Get-NinjaOneRelatedItems [-relatedTo] [-entityType] <String> [[-entityId] <Int64>] [[-scope] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### relatedFrom
```
Get-NinjaOneRelatedItems [-relatedFrom] [-entityType] <String> [[-entityId] <Int64>] [[-scope] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves related items related to a given entity or entity type from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneRelatedItems -all
```

Gets all related items.

### EXAMPLE 2
```
Get-NinjaOneRelatedItems -relatedTo -entityType 'organization'
```

Gets all items which have a relation to an organization.

### EXAMPLE 3
```
Get-NinjaOneRelatedItems -relatedTo -entityType 'organization' -entityId 1
```

Gets all items which have a relation to the organization with id 1.

### EXAMPLE 4
```
Get-NinjaOneRelatedItems -relatedFrom -entityType 'organization'
```

Gets all items which have a relation from an organization.

### EXAMPLE 5
```
Get-NinjaOneRelatedItems -relatedFrom -entityType 'organization' -entityId 1
```

Gets all items which have a relation from the organization with id 1.

## PARAMETERS

### -all
Return all related items.

```yaml
Type: SwitchParameter
Parameter Sets: all
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -relatedTo
Find items related to the given entity type/id.

```yaml
Type: SwitchParameter
Parameter Sets: relatedTo
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -relatedFrom
Find items with related entities of the given type/id.

```yaml
Type: SwitchParameter
Parameter Sets: relatedFrom
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -entityType
The entity type to get related items for.

```yaml
Type: String
Parameter Sets: relatedTo, relatedFrom
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -entityId
The entity id to get related items for.

```yaml
Type: Int64
Parameter Sets: relatedTo, relatedFrom
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -scope
The scope of the related items.

```yaml
Type: String
Parameter Sets: relatedTo, relatedFrom
Aliases:

Required: False
Position: 3
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/relateditems](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/relateditems)

