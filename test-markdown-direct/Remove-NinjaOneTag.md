---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/tag
schema: 2.0.0
---

# Remove-NinjaOneTag

## SYNOPSIS
Deletes a tag.

## SYNTAX

```
Remove-NinjaOneTag [-tagId] <Int32> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Deletes a tag via the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Remove-NinjaOneTag -tagId 12 -Confirm:$false
```

Deletes the tag with Id 12.

## PARAMETERS

### -tagId
{{ Fill tagId Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
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

### Status code (204) on success.
## NOTES

## RELATED LINKS

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/tag](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/tag)

