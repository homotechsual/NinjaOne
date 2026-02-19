---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/groupmembers
schema: 2.0.0
---

# Get-NinjaOneGroupMembers

## SYNOPSIS
Gets group members from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneGroupMembers [-groupId] <Int32> [[-refresh] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Retrieves group members from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneGroupMembers -groupId 1
```

Gets all group members for group with id 1.

## PARAMETERS

### -groupId
The group id to get members for.

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

### -refresh
Refresh ?ToDo Query with Ninja

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/groupmembers](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/groupmembers)

