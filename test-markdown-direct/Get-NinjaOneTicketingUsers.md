---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/ticketingusers
schema: 2.0.0
---

# Get-NinjaOneTicketingUsers

## SYNOPSIS
Gets lists of users from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneTicketingUsers [[-anchorNaturalId] <Int32>] [[-clientId] <Int32>] [[-pageSize] <Int32>]
 [[-searchCriteria] <String>] [[-userType] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves lists of ticketing users  from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneTicketingUsers
```

Gets all ticketing users.
Contacts, end users and technicians.

### EXAMPLE 2
```
Get-NinjaOneTicketingUsers -anchorNaturalId 10
```

Starts the list of users from the user with the natural id 10.

### EXAMPLE 3
```
Get-NinjaOneTicketingUsers -clientId 1
```

Gets all users for the organisation with id 1.

### EXAMPLE 4
```
Get-NinjaOneTicketingUsers -pageSize 10
```

Limits the number of users returned to 10.

### EXAMPLE 5
```
Get-NinjaOneTicketingUsers -searchCriteria 'mikey@homotechsual.dev'
```

Searches for the user with the email address 'mikey@homotechsual.dev'.

### EXAMPLE 6
```
Get-NinjaOneTicketingUsers -userType TECHNICIAN
```

Gets all technician users.

## PARAMETERS

### -anchorNaturalId
Start results from this user natural id.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -clientId
Get users for this organisation id.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: id, organizationId

Required: False
Position: 2
Default value: 0
Accept pipeline input: True (ByPropertyName, ByValue)
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
Accept pipeline input: False
Accept wildcard characters: False
```

### -searchCriteria
The search criteria to apply to the request.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -userType
Filter by user type.
This can be one of "TECHNICIAN", "END_USER" or "CONTACT".

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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/ticketingusers](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/ticketingusers)

