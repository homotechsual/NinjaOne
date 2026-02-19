---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/organisationcustomfields
schema: 2.0.0
---

# Set-NinjaOneOrganisationCustomFields

## SYNOPSIS
Updates an organisation's custom fields.

## SYNTAX

```
Set-NinjaOneOrganisationCustomFields [-organisationId] <Int32> [-organisationCustomFields] <Object>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates organisation custom field values using the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
$OrganisationCustomFields = @{
	field1 = 'value1'
	field2 = 'value2'
}
PS> Update-NinjaOneOrganisationCustomFields -organisationId 1 -organisationCustomFields $OrganisationCustomFields
```

Updates the custom fields for the organisation with id 1.

## PARAMETERS

### -organisationId
The organisation to set the custom fields for.

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

### -organisationCustomFields
The organisation custom field body object.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: customFields, body, organizationCustomFields

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

### A powershell object containing the response.
## NOTES

## RELATED LINKS

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/organisationcustomfields](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/organisationcustomfields)

