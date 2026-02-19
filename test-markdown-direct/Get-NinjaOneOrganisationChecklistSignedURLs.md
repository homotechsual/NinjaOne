---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationchecklist-signedurls
schema: 2.0.0
---

# Get-NinjaOneOrganisationChecklistSignedURLs

## SYNOPSIS
Gets signed URLs for an organisation checklist.

## SYNTAX

```
Get-NinjaOneOrganisationChecklistSignedURLs [-checklistId] <Int32> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Retrieves signed URLs for an organisation checklist via the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneOrganisationChecklistSignedURLs -checklistId 22
```

Gets signed URLs for organisation checklist Id 22.

## PARAMETERS

### -checklistId
{{ Fill checklistId Description }}

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

### A PowerShell object containing the response.
## NOTES

## RELATED LINKS

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationchecklist-signedurls](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationchecklist-signedurls)

