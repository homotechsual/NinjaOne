---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/ticketlogentries
schema: 2.0.0
---

# Get-NinjaOneTicketLogEntries

## SYNOPSIS
Gets ticket log entries from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneTicketLogEntries [-ticketId] <String> [[-createTime] <String>] [[-pageSize] <Int32>]
 [[-type] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves ticket log entries from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneTicketLogEntries -ticketId 1
```

Gets all ticket log entries for ticket with id 1.

### EXAMPLE 2
```
Get-NinjaOneTicketLogEntries -ticketId 1 -type DESCRIPTION
```

Gets all ticket log entries for ticket with id 1 with type DESCRIPTION.

## PARAMETERS

### -ticketId
Filter by ticket id.

```yaml
Type: String
Parameter Sets: (All)
Aliases: id

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -createTime
Filter by create time.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -pageSize
The number of results to return.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -type
Filter log entries by type.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
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

### A powershell object containing the response.
## NOTES

## RELATED LINKS

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/ticketlogentries](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/ticketlogentries)

