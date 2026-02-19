---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/relateditemattachmentsignedurls
schema: 2.0.0
---

# Get-NinjaOneRelatedItemAttachmentSignedURLs

## SYNOPSIS
Gets related item attachment signed URLs from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneRelatedItemAttachmentSignedURLs [-entityType] <String> [-entityId] <Int32>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves a related item attachment signed URLs from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneRelatedItemAttachmentSignedURLs -entityType 'KB_DOCUMENT' -entityId 1
```

Gets the related item attachment signed URLs for the KB_DOCUMENT entity with id 1.

## PARAMETERS

### -entityType
The entity type of the related item.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -entityId
The entity id of the related item.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: id

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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/relateditemattachmentsignedurls](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/relateditemattachmentsignedurls)

