---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationknowledgebasearticles
schema: 2.0.0
---

# Get-NinjaOneOrganisationKnowledgeBaseArticles

## SYNOPSIS
Gets knowledge base articles for organisations from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneOrganisationKnowledgeBaseArticles [[-articleName] <String>] [[-organisationIds] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves knowledge base articles for organisations from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneOrganisationKnowledgeBaseArticles
```

Gets all knowledge base articles for organisations.

### EXAMPLE 2
```
Get-NinjaOneOrganisationKnowledgeBaseArticles -articleName 'Article Name'
```

Gets all knowledge base articles for organisations with the name 'Article Name'.

### EXAMPLE 3
```
Get-NinjaOneOrganisationKnowledgeBaseArticles -organisationIds '1,2,3'
```

Gets all knowledge base articles for organisations with ids 1, 2, and 3.

## PARAMETERS

### -articleName
The knowledge base article name to get.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -organisationIds
The organisation ids to get knowledge base articles for.
Use a comma separated list for multiple ids.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationknowledgebasearticles](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationknowledgebasearticles)

