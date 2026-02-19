---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationdocumentsignedurls
schema: 2.0.0
---

# Get-NinjaOneOrganisationDocumentSignedURLs

## SYNOPSIS
Gets organisation document signed URLs from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneOrganisationDocumentSignedURLs [-clientDocumentId] <Int32> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Retrieves organisation document signed URLs from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneOrganisationDocumentSignedURLs -clientDocumentId 1
```

Gets signed URLs for the organisation document with id 1.

## PARAMETERS

### -clientDocumentId
The client document id to get signed URLs for.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: id, documentId, organisationDocumentId, organizationDocumentId

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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationdocumentsignedurls](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationdocumentsignedurls)

