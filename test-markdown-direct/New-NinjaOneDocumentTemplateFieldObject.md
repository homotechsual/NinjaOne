---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/documenttemplate
schema: 2.0.0
---

# New-NinjaOneDocumentTemplateFieldObject

## SYNOPSIS
Create a new Document Template Field object.

## SYNTAX

### Field
```
New-NinjaOneDocumentTemplateFieldObject [-Label] <String> [-Name] <String> [[-Description] <String>]
 [-Type] <String> [[-TechnicianPermission] <String>] [[-ScriptPermission] <String>] [[-APIPermission] <String>]
 [[-DefaultValue] <String>] [[-Options] <Object[]>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### UIElement
```
New-NinjaOneDocumentTemplateFieldObject [-ElementName] <String> [[-ElementValue] <String>]
 [-ElementType] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Creates a new Document Template Field object containing required / specified properties / structure.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Label
The human readable label for the field.

```yaml
Type: String
Parameter Sets: Field
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The machine readable name for the field.
This is an immutable value.

```yaml
Type: String
Parameter Sets: Field
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The description of the field.

```yaml
Type: String
Parameter Sets: Field
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The type of the field.

```yaml
Type: String
Parameter Sets: Field
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TechnicianPermission
The technician permissions for the field.

```yaml
Type: String
Parameter Sets: Field
Aliases:

Required: False
Position: 5
Default value: NONE
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScriptPermission
The script permissions for the field.

```yaml
Type: String
Parameter Sets: Field
Aliases:

Required: False
Position: 6
Default value: NONE
Accept pipeline input: False
Accept wildcard characters: False
```

### -APIPermission
The API permissions for the field.

```yaml
Type: String
Parameter Sets: Field
Aliases:

Required: False
Position: 7
Default value: NONE
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultValue
The default value for the field.

```yaml
Type: String
Parameter Sets: Field
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Options
The field options (a.k.a the field content).

```yaml
Type: Object[]
Parameter Sets: Field
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ElementName
When creating a UI element (e.g a title, separator or description box) this is the machine readable name of the UI element.

```yaml
Type: String
Parameter Sets: UIElement
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ElementValue
When creating a UI element (e.g a title, separator or description box) this is the value of the UI element.

```yaml
Type: String
Parameter Sets: UIElement
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ElementType
When creating a UI element (e.g a title, separator or description box) this is the type of the UI element.

```yaml
Type: String
Parameter Sets: UIElement
Aliases:

Required: True
Position: 3
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

### [Object]
### A new Document Template Field or UI Element object.
## NOTES

## RELATED LINKS
