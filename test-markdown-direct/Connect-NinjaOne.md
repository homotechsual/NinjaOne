---
external help file: NinjaOne-help.xml
Module Name: NinjaOne
online version: https://docs.homotechsual.dev/modules/ninjaone/commandlets/Connect/ninjaone
schema: 2.0.0
---

# Connect-NinjaOne

## SYNOPSIS
Creates a new connection to a NinjaOne instance.

## SYNTAX

### Authorisation Code (Default)
```
Connect-NinjaOne [-UseWebAuth] -Instance <String> -ClientId <String> -ClientSecret <String>
 [-Scopes <String[]>] [-RedirectURL <Uri>] [-Port <Int32>] [-ShowTokens] [-UseSecretManagement]
 [-VaultName <String>] [-WriteToSecretVault] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Secret Vault Write
```
Connect-NinjaOne [-UseWebAuth] [-UseTokenAuth] [-UseClientAuth] -Instance <String> -ClientId <String>
 -ClientSecret <String> [-Scopes <String[]>] [-RedirectURL <Uri>] [-Port <Int32>] [-RefreshToken <String>]
 [-UseSecretManagement] -VaultName <String> [-WriteToSecretVault] [-SecretPrefix <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Token Authentication
```
Connect-NinjaOne [-UseTokenAuth] -Instance <String> -ClientId <String> -ClientSecret <String>
 [-Scopes <String[]>] [-RefreshToken <String>] [-ShowTokens] [-UseSecretManagement] [-VaultName <String>]
 [-WriteToSecretVault] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Client Credentials
```
Connect-NinjaOne [-UseClientAuth] -Instance <String> -ClientId <String> -ClientSecret <String>
 [-Scopes <String[]>] [-ShowTokens] [-UseSecretManagement] [-VaultName <String>] [-WriteToSecretVault]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Secret Vault Read
```
Connect-NinjaOne [-UseSecretManagement] -VaultName <String> [-WriteToSecretVault] [-ReadFromSecretVault]
 [-SecretPrefix <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Creates a new connection to a NinjaOne instance and stores this in a PowerShell Session.

## EXAMPLES

### EXAMPLE 1
```
Connect-NinjaOne -Instance 'eu' -ClientId 'AAaaA1aaAaAA-aaAaaA11a1A-aA' -ClientSecret '00Z00zzZzzzZzZzZzZzZZZ0zZ0zzZ_0zzz0zZZzzZz0Z0ZZZzz0z0Z' -UseClientAuth
```

This logs into NinjaOne using the client credentials flow.

### EXAMPLE 2
```
Connect-NinjaOne -Instance 'eu' -ClientId 'AAaaA1aaAaAA-aaAaaA11a1A-aA' -ClientSecret '00Z00zzZzzzZzZzZzZzZZZ0zZ0zzZ_0zzz0zZZzzZz0Z0ZZZzz0z0Z' -Port 9090 -UseWebAuth
```

This logs into NinjaOne using the authorization code flow.

### EXAMPLE 3
```
Connect-NinjaOne -Instance 'eu' -ClientId 'AAaaA1aaAaAA-aaAaaA11a1A-aA' -ClientSecret '00Z00zzZzzzZzZzZzZzZZZ0zZ0zzZ_0zzz0zZZzzZz0Z0ZZZzz0z0Z' -RefreshToken 'a1a11a11-aa11-11a1-a111-a1a111aaa111.11AaaAaaa11aA-AA1aaaAAA111aAaaaaA1AAAA1_AAa' -UseTokenAuth
```

This logs into NinjaOne using the refresh token flow.

### EXAMPLE 4
```
Connect-NinjaOne -UseSecretManagement -VaultName 'NinjaOneVault' -WriteToSecretVault -Instance 'eu' -ClientId 'AAaaA1aaAaAA-aaAaaA11a1A-aA' -ClientSecret '00Z00zzZzzzZzZzZzZzZZZ0zZ0zzZ_0zzz0zZZzzZz0Z0ZZZzz0z0Z' -UseClientAuth
```

This logs into NinjaOne using the client credentials flow and writes the connection information to the secret vault.

### EXAMPLE 5
```
Connect-NinjaOne -UseSecretManagement -VaultName 'NinjaOneVault' -ReadFromSecretVault
```

This reads the connection information from the secret vault.

## PARAMETERS

### -UseWebAuth
Use the "Authorisation Code" flow with your web browser.

```yaml
Type: SwitchParameter
Parameter Sets: Authorisation Code
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: SwitchParameter
Parameter Sets: Secret Vault Write
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseTokenAuth
Use the "Token Authentication" flow - useful if you already have a refresh token.

```yaml
Type: SwitchParameter
Parameter Sets: Secret Vault Write
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: SwitchParameter
Parameter Sets: Token Authentication
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseClientAuth
Use the "Client Credentials" flow - useful if you already have a client ID and secret.

```yaml
Type: SwitchParameter
Parameter Sets: Secret Vault Write
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: SwitchParameter
Parameter Sets: Client Credentials
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Instance
The NinjaOne instance to connect to.
Choose from 'eu', 'oc' or 'us'.

```yaml
Type: String
Parameter Sets: Authorisation Code, Secret Vault Write, Token Authentication, Client Credentials
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientId
The Client Id for the application configured in NinjaOne.

```yaml
Type: String
Parameter Sets: Authorisation Code, Secret Vault Write, Token Authentication, Client Credentials
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientSecret
The Client Secret for the application configured in NinjaOne.

```yaml
Type: String
Parameter Sets: Authorisation Code, Secret Vault Write, Token Authentication, Client Credentials
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Scopes
The API scopes to request, if this isn't passed the scope is assumed to be "all".
Pass a string or array of strings.
Limited by the scopes granted to the application in NinjaOne.

```yaml
Type: String[]
Parameter Sets: Authorisation Code, Secret Vault Write, Token Authentication, Client Credentials
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RedirectURL
The redirect URI to use.
If not set defaults to 'http://localhost'.
Should be a full URI e.g.
https://redirect.example.uk:9090/auth

```yaml
Type: Uri
Parameter Sets: Authorisation Code, Secret Vault Write
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
The port to use for the redirect URI.
Must match with the configuration set in NinjaOne.
If not set defaults to '9090'.

```yaml
Type: Int32
Parameter Sets: Authorisation Code, Secret Vault Write
Aliases:

Required: False
Position: Named
Default value: 9090
Accept pipeline input: False
Accept wildcard characters: False
```

### -RefreshToken
The refresh token to use for "Token Authentication" flow.

```yaml
Type: String
Parameter Sets: Secret Vault Write, Token Authentication
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowTokens
Output the tokens - useful when using "Authorisation Code" flow - to use with "Token Authentication" flow.

```yaml
Type: SwitchParameter
Parameter Sets: Authorisation Code, Token Authentication, Client Credentials
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseSecretManagement
Use the secret management module to retrieve credentials and store tokens.
Check the docs on setting up the secret management module at https://docs.homotechsual.dev/common/secretmanagement.

```yaml
Type: SwitchParameter
Parameter Sets: Authorisation Code, Token Authentication, Client Credentials
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: SwitchParameter
Parameter Sets: Secret Vault Write, Secret Vault Read
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -VaultName
The name of the secret vault to use.

```yaml
Type: String
Parameter Sets: Authorisation Code, Token Authentication, Client Credentials
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Secret Vault Write, Secret Vault Read
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WriteToSecretVault
Write updated credentials to secret management vault.

```yaml
Type: SwitchParameter
Parameter Sets: Authorisation Code, Token Authentication, Client Credentials, Secret Vault Read
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: SwitchParameter
Parameter Sets: Secret Vault Write
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReadFromSecretVault
Read the authentication information from secret management vault.

```yaml
Type: SwitchParameter
Parameter Sets: Secret Vault Read
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecretPrefix
The prefix to add to the name of the secrets stored in the secret vault.

```yaml
Type: String
Parameter Sets: Secret Vault Write, Secret Vault Read
Aliases:

Required: False
Position: Named
Default value: NinjaOne
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

### Sets two script-scoped variables to hold connection and authentication information.
## NOTES

## RELATED LINKS

[https://docs.homotechsual.dev/modules/ninjaone/commandlets/Connect/ninjaone](https://docs.homotechsual.dev/modules/ninjaone/commandlets/Connect/ninjaone)

