---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/tab-role-visibility
schema: 2.0.0
---

# Set-NinjaOneTabRoleVisibility

## SYNOPSIS
Sets tab visibility for a role.

## SYNTAX

```
Set-NinjaOneTabRoleVisibility [-roleId] <Int32> [-visibility] <Object> [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Configures tab visibility for a specific role via the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Set-NinjaOneTabRoleVisibility -roleId 10 -visibility @(
	@{ tabId = 1; visible = $true },
	@{ tabId = 2; visible = $false }
)
```

Sets visibility for tabs on role 10.

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

### -visibility
Array payload (CustomTabsVisibilityPublicApiDTO\[\])

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

### Updated visibility data per API.
## NOTES

## RELATED LINKS

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/tab-role-visibility](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/tab-role-visibility)

