---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/knowledgebasearticle
schema: 2.0.0
---

# Get-NinjaOneRelatedItemAttachment

## SYNOPSIS
Gets a related item attachment from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneRelatedItemAttachment [-relatedItemId] <Int32> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Retrieves a related item attachment from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneKnowledgeBaseArticle -articleId 1
```

Gets the knowledge base article with id 1.

## PARAMETERS

### -relatedItemId
The related item id to get the attachment for.

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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/knowledgebasearticle](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/knowledgebasearticle)

