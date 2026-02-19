---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/knowledgebasefolders
schema: 2.0.0
---

# Get-NinjaOneKnowledgeBaseFolders

## SYNOPSIS
Gets knowledge base folders from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneKnowledgeBaseFolders [[-folderId] <Int32>] [[-folderPath] <String>] [[-organisationId] <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves knowledge base folders and information on their contents from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneKnowledgeBaseFolders
```

Gets all knowledge base folders.

### EXAMPLE 2
```
Get-NinjaOneKnowledgeBaseFolders -folderId 1
```

Gets the knowledge base folder with id 1.

### EXAMPLE 3
```
Get-NinjaOneKnowledgeBaseFolders -folderPath 'Folder/Subfolder'
```

Gets the knowledge base folder with the path 'Folder/Subfolder'.

### EXAMPLE 4
```
Get-NinjaOneKnowledgeBaseFolders -organisationId 1
```

Gets all knowledge base folders for the organisation with id 1.

## PARAMETERS

### -folderId
The knowledge base folder id to get.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: id

Required: False
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -folderPath
The knowledge base folder path to get.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -organisationId
The organisation id to get knowledge base folders for.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/knowledgebasefolders](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/knowledgebasefolders)

