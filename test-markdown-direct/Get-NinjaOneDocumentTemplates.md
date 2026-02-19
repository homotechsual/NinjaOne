---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/documenttemplate
schema: 2.0.0
---

# Get-NinjaOneDocumentTemplates

## SYNOPSIS
Gets one or more document templates from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneDocumentTemplates [[-documentTemplateId] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Retrieves one or more document templates from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneDocumentTemplate
```

Retrieves all document templates with their fields.

### EXAMPLE 2
```
Get-NinjaOneDocumentTemplate -documentTemplateId 1
```

## PARAMETERS

### -documentTemplateId
The document template id to retrieve.

```yaml
Type: String
Parameter Sets: (All)
Aliases: id

Required: False
Position: 1
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/documenttemplate](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/documenttemplate)

