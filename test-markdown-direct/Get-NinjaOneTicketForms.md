---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/ticketforms
schema: 2.0.0
---

# Get-NinjaOneTicketForms

## SYNOPSIS
Gets ticket forms from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneTicketForms [[-ticketFormId] <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves ticket forms from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneTicketForms
```

Gets all ticket forms.

### EXAMPLE 2
```
Get-NinjaOneTicketForms -ticketFormId 1
```

Gets ticket form with id 1.

## PARAMETERS

### -ticketFormId
Ticket form id.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: id

Required: False
Position: 1
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

### A powershell object containing the response.
## NOTES

## RELATED LINKS

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/ticketforms](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/ticketforms)

