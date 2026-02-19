---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/backupusagequery
schema: 2.0.0
---

# Get-NinjaOneDeviceBackupUsage

## SYNOPSIS
Gets the backup usage by device from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneDeviceBackupUsage [[-cursor] <String>] [[-pageSize] <Int32>] [-includeDeleted]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves the backup usage by device from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneBackupUsage
```

Gets the backup usage by device.

### EXAMPLE 2
```
Get-NinjaOneBackupUsage -includeDeleted
```

Gets the backup usage by device including deleted devices.

### EXAMPLE 3
```
Get-NinjaOneBackupUsage | Where-Object { ($_.references.backupUsage.cloudTotalSize -ne 0) -or ($_.references.backupUsage.localTotalSize -ne 0) }
```

Gets the backup usage by device where the cloud or local total size is not 0.

### EXAMPLE 4
```
Get-NinjaOneBackupUsage -includeDeleted | Where-Object { ($_.references.backupUsage.cloudTotalSize -ne 0) -and ($_.references.backupUsage.localTotalSize -ne 0) -and ($_.references.backupUsage.revisionsTotalSize -ne 0) }
```

Gets the backup usage where the cloud, local and revisions total size is not 0 including deleted devices.

## PARAMETERS

### -cursor
Cursor name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -pageSize
Number of results per page.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -includeDeleted
Include deleted devices.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: includeDeletedDevices

Required: False
Position: Named
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

### A powershell object containing the response.
## NOTES

## RELATED LINKS

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/backupusagequery](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/backupusagequery)

