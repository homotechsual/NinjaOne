---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/securevaluerelation
schema: 2.0.0
---

# New-NinjaOneSecureRelation

## SYNOPSIS
Creates a new secure value relation using the NinjaOne API.

## SYNTAX

```
New-NinjaOneSecureRelation [-entityType] <String> [-entityId] <Int32> [-secureValueName] <String>
 [[-secureValueURL] <String>] [[-secureValueNotes] <String>] [[-secureValueUsername] <String>]
 [[-secureValuePassword] <String>] [-show] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Create a new secure value relation using the NinjaOne v2 API.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -entityType
The entity type to create the secre relation for.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -entityId
The entity id to create the secucre relation for.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: id

Required: True
Position: 2
Default value: 0
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -secureValueName
The name of the secure value.

```yaml
Type: String
Parameter Sets: (All)
Aliases: name

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -secureValueURL
The URL for the secure value.

```yaml
Type: String
Parameter Sets: (All)
Aliases: url, uri

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -secureValueNotes
Notes to accompany the secure value.

```yaml
Type: String
Parameter Sets: (All)
Aliases: notes

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -secureValueUsername
The username for the secure value.

```yaml
Type: String
Parameter Sets: (All)
Aliases: username

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -secureValuePassword
The password for the secure value.

```yaml
Type: String
Parameter Sets: (All)
Aliases: password

Required: False
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -show
Show the secure relation that was created.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/securevaluerelation](https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/securevaluerelation)

