---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisations
schema: 2.0.0
---

# Get-NinjaOneOrganisations

## SYNOPSIS
Gets organisations from the NinjaOne API.

## SYNTAX

### Multi (Default)
```
Get-NinjaOneOrganisations [[-after] <Int32>] [[-organisationFilter] <String>] [[-pageSize] <Int32>] [-detailed]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Single
```
Get-NinjaOneOrganisations [[-organisationId] <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves organisations from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneOrganisations
```

Gets all organisations.

### EXAMPLE 2
```
Get-NinjaOneOrganisations -organisationId 1
```

Gets the organisation with id 1.

### EXAMPLE 3
```
Get-NinjaOneOrganisations -pageSize 10 -after 1
```

Gets 10 organisations starting from organisation id 1.

### EXAMPLE 4
```
Get-NinjaOneOrganisations -detailed
```

Gets all organisations with locations and policy mappings.

## PARAMETERS

### -organisationId
Organisation id

```yaml
Type: Int32
Parameter Sets: Single
Aliases: id, organizationId

Required: False
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -after
Start results from organisation id.

```yaml
Type: Int32
Parameter Sets: Multi
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -organisationFilter
Filter results using an organisation filter string.

```yaml
Type: String
Parameter Sets: Multi
Aliases: of, organizationFilter

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -pageSize
Number of results per page.

```yaml
Type: Int32
Parameter Sets: Multi
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisations](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisations)

