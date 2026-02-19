---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/customfieldspolicycondition
schema: 2.0.0
---

# Get-NinjaOneCustomFieldsPolicyCondition

## SYNOPSIS
Gets detailed information on a single custom field condition for a given policy from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneCustomFieldsPolicyCondition [-policyId] <Int32> [-conditionId] <Int32>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves the detailed information on a given custom field condition for a given policy id from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneCustomFieldsPolicyCondition -policyId 1 -conditionId 1
```

Gets the custom field policy condition with id 1 for the policy with id 1.

## PARAMETERS

### -policyId
The policy id to get the custom field conditions for.

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

### -conditionId
The condition id to get the custom field condition for.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/customfieldspolicycondition](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/customfieldspolicycondition)

