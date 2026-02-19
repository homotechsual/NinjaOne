---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/tab-enduser-order
schema: 2.0.0
---

# Set-NinjaOneTabEndUserOrder

## SYNOPSIS
Updates the order of custom tabs for end-user tabs.

## SYNTAX

```
Set-NinjaOneTabEndUserOrder [-order] <Object> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Updates the order of custom tabs for end-user tabs via the NinjaOne v2 API.
NOTE: All tabs defined for end-users must be specified in the payload.

## EXAMPLES

### EXAMPLE 1
```
Set-NinjaOneTabEndUserOrder -order @(
	@{ tabId = 1; order = 1 },
	@{ tabId = 2; order = 2 }
)
```

Sets the order of the end-user tabs.

## PARAMETERS

### -order
Array payload specifying the tab order per API schema (CustomTabsOrderPublicApiDTO\[\])

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

### Status code or updated order data per API.
## NOTES

## RELATED LINKS

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/tab-enduser-order](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/tab-enduser-order)

