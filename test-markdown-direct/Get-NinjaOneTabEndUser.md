---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/tab-enduser
schema: 2.0.0
---

# Get-NinjaOneTabEndUser

## SYNOPSIS
Gets the end-user for a tab.

## SYNTAX

```
Get-NinjaOneTabEndUser [-tabId] <Int32> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves the end-user associated with a tab via the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneTabEndUser -tabId 5
```

Gets the end-user for tab Id 5.

## PARAMETERS

### -tabId
{{ Fill tabId Description }}

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

### A PowerShell object containing the response.
## NOTES

## RELATED LINKS

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/tab-enduser](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/tab-enduser)

