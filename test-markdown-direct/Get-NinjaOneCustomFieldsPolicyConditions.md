---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/customfieldspolicyconditions
schema: 2.0.0
---

# Get-NinjaOneCustomFieldsPolicyConditions

## SYNOPSIS
Gets custom field conditions for a given policy from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneCustomFieldsPolicyConditions [-policyId] <Int32> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Retrieves the custom field conditions for a given policy id from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneCustomFieldsPolicyConditions -policyId 1
```

Gets the custom field policy conditions for the policy with id 1.

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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/customfieldspolicyconditions](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/customfieldspolicyconditions)

