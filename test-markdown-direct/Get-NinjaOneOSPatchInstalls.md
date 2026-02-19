---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/ospatchinstallsquery
schema: 2.0.0
---

# Get-NinjaOneOSPatchInstalls

## SYNOPSIS
Gets the OS patch installs from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneOSPatchInstalls [[-deviceFilter] <String>] [[-timeStamp] <DateTime>]
 [[-timeStampUnixEpoch] <Int32>] [[-status] <String>] [[-installedBefore] <DateTime>]
 [[-installedBeforeUnixEpoch] <Int32>] [[-installedAfter] <DateTime>] [[-installedAfterUnixEpoch] <Int32>]
 [[-cursor] <String>] [[-pageSize] <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves the OS patch installs from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneOSPatchInstalls
```

Gets all OS patch installs.

### EXAMPLE 2
```
Get-NinjaOneOSPatchInstalls -deviceFilter 'org = 1'
```

Gets the OS patch installs for the organisation with id 1.

### EXAMPLE 3
```
Get-NinjaOneOSPatchInstalls -timeStamp 1619712000
```

Gets the OS patch installs with a monitoring timestamp at or after 1619712000.

### EXAMPLE 4
```
Get-NinjaOneOSPatchInstalls -status 'FAILED'
```

Gets the OS patch installs with a status of 'FAILED'.

### EXAMPLE 5
```
Get-NinjaOneOSPatchInstalls -installedBefore (Get-Date)
```

Gets the OS patch installs installed before the current date.

### EXAMPLE 6
```
Get-NinjaOneOSPatchInstalls -installedBeforeUnixEpoch 1619712000
```

Gets the OS patch installs installed before 1619712000.

### EXAMPLE 7
```
Get-NinjaOneOSPatchInstalls -installedAfter (Get-Date).AddDays(-1)
```

Gets the OS patch installs installed after the previous day.

### EXAMPLE 8
```
Get-NinjaOneOSPatchInstalls -installedAfterUnixEpoch 1619712000
```

Gets the OS patch installs installed after 1619712000.

## PARAMETERS

### -deviceFilter
Filter devices.

```yaml
Type: String
Parameter Sets: (All)
Aliases: df

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -timeStamp
Monitoring timestamp filter.
PowerShell DateTime object.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases: ts

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -timeStampUnixEpoch
Monitoring timestamp filter.
Unix Epoch time.

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

### -status
Filter patches by patch status.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -installedBefore
Filter patches to those installed before this date.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -installedBeforeUnixEpoch
Filter patches to those installed after this date.
Unix Epoch time.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -installedAfter
Filter patches to those installed after this date.
PowerShell DateTime object.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -installedAfterUnixEpoch
Filter patches to those installed after this date.
Unix Epoch time.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -cursor
Cursor name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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
Position: 7
Default value: 0
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/ospatchinstallsquery](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/ospatchinstallsquery)

