---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/entityrelation
schema: 2.0.0
---

# New-NinjaOneEntityRelationObject

## SYNOPSIS
Create a new Entity Relation object.

## SYNTAX

```
New-NinjaOneEntityRelationObject [[-Entity] <EntityType>] [[-relationEntityType] <EntityType>]
 [[-Operator] <FilterOperator>] [[-Value] <Object>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Creates a new Entity Relation object containing required / specified properties / structure.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Entity
The entity type of the relation.

```yaml
Type: EntityType
Parameter Sets: (All)
Aliases:
Accepted values: ORGANIZATION, DOCUMENT, LOCATION, NODE, ATTACHMENT, TECHNICIAN, CREDENTIAL, CHECKLIST, END_USER, CONTACT, KB_DOCUMENT

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -relationEntityType
{{ Fill relationEntityType Description }}

```yaml
Type: EntityType
Parameter Sets: (All)
Aliases:
Accepted values: ORGANIZATION, DOCUMENT, LOCATION, NODE, ATTACHMENT, TECHNICIAN, CREDENTIAL, CHECKLIST, END_USER, CONTACT, KB_DOCUMENT

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Operator
{{ Fill Operator Description }}

```yaml
Type: FilterOperator
Parameter Sets: (All)
Aliases:
Accepted values: present, not_present, is, is_not, contains, not_contains, contains_any, contains_none, greater_than, less_than, greater_or_equal_than, less_or_equal_than, between

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
{{ Fill Value Description }}

```yaml
Type: Object
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

### [Object]
### A new Document Template Field or UI Element object.
## NOTES

## RELATED LINKS
