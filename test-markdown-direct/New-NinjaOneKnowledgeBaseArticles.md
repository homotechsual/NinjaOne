---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/knowledgebase-articles
schema: 2.0.0
---

# New-NinjaOneKnowledgeBaseArticles

## SYNOPSIS
Creates knowledge base articles.

## SYNTAX

```
New-NinjaOneKnowledgeBaseArticles [-articles] <Object> [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates one or more knowledge base articles via the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
New-NinjaOneKnowledgeBaseArticles -articles @{ organizationId = 1; folderId = 10; articles = @(@{ name='A'; content='...'} ) }
```

Creates knowledge base articles in the specified folder.

## PARAMETERS

### -articles
Articles payload per API schema

```yaml
Type: Object
Parameter Sets: (All)
Aliases: body

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
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

### A PowerShell object containing the created articles or job result.
## NOTES

## RELATED LINKS

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/knowledgebase-articles](https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/knowledgebase-articles)

