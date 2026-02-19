---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/apirequest
schema: 2.0.0
---

# Invoke-NinjaOneRequest

## SYNOPSIS
Sends a request to the NinjaOne API.

## SYNTAX

```
Invoke-NinjaOneRequest [-Method] <String> [-Uri] <String> [[-Body] <String>] [-Raw]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Wrapper function to send web requests to the NinjaOne API.

## EXAMPLES

### EXAMPLE 1
```
Invoke-NinjaOneRequest -Method 'GET' -Uri 'https://eu.ninjarmm.com/v2/activities'
```

Make a GET request to the activities resource.

## PARAMETERS

### -Method
HTTP method to use.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Uri
The URI to send the request to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Body
The body of the request.

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

### -Raw
Return the raw response - don't convert from JSON.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

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

### Outputs an object containing the response from the web request.
## NOTES

## RELATED LINKS

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/apirequest](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/apirequest)

