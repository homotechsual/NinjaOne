---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationlocations
schema: 2.0.0
---

# Get-NinjaOneOrganisationLocations

## SYNOPSIS
Wrapper command using \`Get-NinjaOneLocations\` to get locations for an organisation.

## SYNTAX

```
Get-NinjaOneOrganisationLocations [-organisationId] <Int32> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Gets locations for an organisation using the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneOrganisationLocations -organisationId 1
```

Gets locations for the organisation with id 1.

## PARAMETERS

### -organisationId
Filter by organisation id.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: id, organizationId

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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationlocations](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationlocations)

