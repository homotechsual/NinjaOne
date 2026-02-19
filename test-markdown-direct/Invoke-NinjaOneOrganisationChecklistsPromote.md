---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/organisationchecklists-promote
schema: 2.0.0
---

# Invoke-NinjaOneOrganisationChecklistsPromote

## SYNOPSIS
Promotes organisation checklists.

## SYNTAX

```
Invoke-NinjaOneOrganisationChecklistsPromote [-request] <Object> [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Promotes organisation checklists via the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Invoke-NinjaOneOrganisationChecklistsPromote -request @{ checklistIds=@(1,2) }
```

Promotes the specified organisation checklists.

## PARAMETERS

### -request
{{ Fill request Description }}

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

### A PowerShell object containing the response.
## NOTES

## RELATED LINKS

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/organisationchecklists-promote](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/organisationchecklists-promote)

