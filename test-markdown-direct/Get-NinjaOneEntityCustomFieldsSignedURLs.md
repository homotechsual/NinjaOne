---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/customfields-signedurls
schema: 2.0.0
---

# Get-NinjaOneEntityCustomFieldsSignedURLs

## SYNOPSIS
Gets signed URLs for custom fields on an entity.

## SYNTAX

```
Get-NinjaOneEntityCustomFieldsSignedURLs [-entityType] <String> [-entityId] <Int32>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves signed URLs for custom fields for a given entity type and Id via the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneEntityCustomFieldsSignedURLs -entityType ORGANIZATION -entityId 1
```

Gets custom field signed URLs for the ORGANIZATION entity with Id 1.

## PARAMETERS

### -entityType
The entity type.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -entityId
The entity Id.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: 0
Accept pipeline input: True (ByPropertyName)
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/customfields-signedurls](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/customfields-signedurls)

