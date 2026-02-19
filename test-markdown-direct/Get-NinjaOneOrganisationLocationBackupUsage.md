---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/locationbackupusage
schema: 2.0.0
---

# Get-NinjaOneOrganisationLocationBackupUsage

## SYNOPSIS
Gets backup usage for a location from the NinjaOne API.

## SYNTAX

```
Get-NinjaOneOrganisationLocationBackupUsage [-organisationId] <Int32> [[-locationId] <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves backup usage for a location from the NinjaOne v2 API.
For all locations omit the \`locationId\` parameter for devices backup usage use \`Get-NinjaOneBackupUsage\`.

## EXAMPLES

### EXAMPLE 1
```
Get-NinjaOneLocationBackupUsage -organisationId 1
```

Gets backup usage for all locations in the organisation with id 1.

### EXAMPLE 2
```
Get-NinjaOneLocationBackupUsage -organisationId 1 -locationId 1
```

Gets backup usage for the location with id 1 in the organisation with id 1.

## PARAMETERS

### -organisationId
Organisation id to retrieve backup usage for.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: id, organizationId

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -locationId
Location id to retrieve backup usage for.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/locationbackupusage](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/locationbackupusage)

