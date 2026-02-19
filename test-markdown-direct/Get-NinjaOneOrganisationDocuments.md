---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationdocuments
schema: 2.0.0
---

# Get-NinjaOneOrganisationDocuments

## SYNOPSIS
Gets organisation documents from the NinjaOne API.

## SYNTAX

### Single Organisation
```
Get-NinjaOneOrganisationDocuments [-organisationId] <Int32> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### All Organisations
```
Get-NinjaOneOrganisationDocuments [[-documentName] <String>] [[-groupBy] <String>]
 [[-organisationIds] <String>] [[-templateIds] <String>] [[-templateName] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves organisation documents from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneOrganisationDocuments -organisationId 1
```

Gets documents for the organisation with id 1.

## PARAMETERS

### -organisationId
Filter by organisation id.

```yaml
Type: Int32
Parameter Sets: Single Organisation
Aliases: id, organizationId

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -documentName
Filter by document name.

```yaml
Type: String
Parameter Sets: All Organisations
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -groupBy
Group by template or organisation.

```yaml
Type: String
Parameter Sets: All Organisations
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -organisationIds
Filter by organisation ids.
Comma separated list of organisation ids.

```yaml
Type: String
Parameter Sets: All Organisations
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -templateIds
Filter by template ids.
Comma separated list of template ids.

```yaml
Type: String
Parameter Sets: All Organisations
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -templateName
Filter by template name.

```yaml
Type: String
Parameter Sets: All Organisations
Aliases:

Required: False
Position: 6
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationdocuments](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationdocuments)

