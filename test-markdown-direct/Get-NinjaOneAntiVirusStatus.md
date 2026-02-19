---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/antivirusstatusquery
schema: 2.0.0
---

# Get-NinjaOneAntiVirusStatus

## SYNOPSIS
Gets the antivirus status from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneAntiVirusStatus [[-deviceFilter] <String>] [[-timeStamp] <DateTime>]
 [[-timeStampUnixEpoch] <Int32>] [[-productState] <String>] [[-productName] <String>] [[-cursor] <String>]
 [[-pageSize] <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves the antivirus status from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneAntivirusStatus -deviceFilter 'org = 1'
```

Gets the antivirus status for the organisation with id 1.

### EXAMPLE 2
```
Get-NinjaOneAntivirusStatus -timeStamp 1619712000
```

Gets the antivirus status at or after the timestamp 1619712000.

### EXAMPLE 3
```
Get-NinjaOneAntivirusStatus -productState 'ON'
```

Gets the antivirus status where the product state is ON.

### EXAMPLE 4
```
Get-NinjaOneAntivirusStatus -productName 'Microsoft Defender Antivirus'
```

Gets the antivirus status where the antivirus product name is Microsoft Defender Antivirus.

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
Monitoring timestamp filter in unix time.

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

### -productState
Filter by product state.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -productName
Filter by product name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -cursor
Cursor name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
Position: 6
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/antivirusstatusquery](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/antivirusstatusquery)

