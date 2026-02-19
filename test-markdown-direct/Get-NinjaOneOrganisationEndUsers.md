---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisation-endusers
schema: 2.0.0
---

# Get-NinjaOneOrganisationEndUsers

## SYNOPSIS
Gets end users for an organisation.

## SYNTAX

```
Get-NinjaOneOrganisationEndUsers [-organisationId] <Int32> [-includeRoles] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Returns list of end users for a specific organisation via the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneOrganisationEndUsers -organisationId 1 -includeRoles
```

Gets end users for organisation 1 including roles.

## PARAMETERS

### -organisationId
{{ Fill organisationId Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: organizationId

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -includeRoles
Includes user role information

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: False
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisation-endusers](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisation-endusers)

