---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/policyoverridesquery
schema: 2.0.0
---

# Get-NinjaOnePolicyOverrides

## SYNOPSIS
Gets the policy overrides by device from the NinjaOne API.

## SYNTAX

```
Get-NinjaOnePolicyOverrides [[-cursor] <String>] [[-deviceFilter] <String>] [[-pageSize] <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves the policy override sections by device from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOnePolicyOverrides
```

Gets the policy overrides by device.

### EXAMPLE 2
```
Get-NinjaOnePolicyOverrides -deviceFilter 'org = 1'
```

Gets the policy overrides by device for the organisation with id 1.

## PARAMETERS

### -cursor
Cursor name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -deviceFilter
Device filter.

```yaml
Type: String
Parameter Sets: (All)
Aliases: df

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -pageSize
Number of results per page.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
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

### A powershell object containing the response.
## NOTES

## RELATED LINKS

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/policyoverridesquery](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/policyoverridesquery)

