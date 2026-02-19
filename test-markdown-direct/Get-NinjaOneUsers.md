---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/users
schema: 2.0.0
---

# Get-NinjaOneUsers

## SYNOPSIS
Gets users from the NinjaOne API.

## SYNTAX

### Default (Default)
```
Get-NinjaOneUsers [[-userType] <String>] [-includeRoles] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Organisation
```
Get-NinjaOneUsers [-organisationId] <Int32> [[-userType] <String>] [-includeRoles]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves users from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneUsers
```

Gets all users.

### EXAMPLE 2
```
Get-NinjaOneUsers -includeRoles
```

Gets all users including information about their roles.

### EXAMPLE 3
```
Get-NinjaOneUsers -userType TECHNICIAN
```

Gets all technicians (users with the TECHNICIAN user type).

### EXAMPLE 4
```
Get-NinjaOneUsers -organisationId 1
```

Gets all users for the organisation with id 1 (only works for users with the END_USER user type).

## PARAMETERS

### -organisationId
Get users for this organisation id.

```yaml
Type: Int32
Parameter Sets: Organisation
Aliases: id, organizationId

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -userType
Filter by user type.
This can be one of "TECHNICIAN" or "END_USER".

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

### -includeRoles
Include roles in the response.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: False
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/users](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/users)

