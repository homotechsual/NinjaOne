---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/installer
schema: 2.0.0
---

# Get-NinjaOneInstaller

## SYNOPSIS
Gets agent installer URL from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneInstaller [-organisationId] <Int32> [-locationId] <Int32> [-installerType] <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves agent installer URL from the NinjaOne v2 API.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneInstaller -organisationId 1 -locationId 1 -installerType WINDOWS_MSI
```

Gets the agent installer URL for the location with id 1 in the organisation with id 1 for the Windows MSI installer.

### EXAMPLE 2
```
Get-NinjaOneInstaller -organisationId 1 -locationId 1 -installerType MAC_PKG
```

Gets the agent installer URL for the location with id 1 in the organisation with id 1 for the Mac PKG installer.

## PARAMETERS

### -organisationId
The organisation id to get the installer for.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: id, organizationId

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -locationId
The location id to get the installer for.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -installerType
Installer type/platform.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/installer](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/installer)

