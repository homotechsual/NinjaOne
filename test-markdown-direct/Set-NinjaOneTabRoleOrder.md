---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/tab-role-order
schema: 2.0.0
---

# Set-NinjaOneTabRoleOrder

## SYNOPSIS
Updates the order of custom tabs for a specific role.

## SYNTAX

```
Set-NinjaOneTabRoleOrder [-roleId] <Int32> [-order] <Object> [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates the order of custom tabs for a role via the NinjaOne v2 API.
NOTE: Only tabs created on this role can be ordered.
All tabs on the role must be specified.

## EXAMPLES

### EXAMPLE 1
```
Set-NinjaOneTabRoleOrder -roleId 10 -order @(
	@{ tabId = 1; order = 1 },
	@{ tabId = 2; order = 2 }
)
```

Sets the role tabs order for role 10.

## PARAMETERS

### -roleId
{{ Fill roleId Description }}

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

### -order
Array payload specifying the tab ordering (CustomTabsOrderPublicApiDTO\[\])

```yaml
Type: Object
Parameter Sets: (All)
Aliases: body

Required: True
Position: 2
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

### Updated order data per API.
## NOTES

## RELATED LINKS

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/tab-role-order](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/tab-role-order)

