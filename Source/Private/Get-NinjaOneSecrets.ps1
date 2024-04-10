function Get-NinjaOneSecrets {
    <#
        .SYNOPSIS
            Retrieves NinjaOne connection and authentication using the SecretManagement module.
        .DESCRIPTION
            Handles the retrieval of NinjaOne connection and authentication information using the SecretManagement module. This function is intended to be used internally by the module and should not be called directly.
        .OUTPUTS
            [System.Void]

            Returns nothing.
    #>
    [CmdletBinding()]
    [OutputType([System.Void])]
    param(
        # The vault name to use for retrieving the secrets.
        [String]$VaultName,
        # The prefix to use for the secret names.
        [String]$SecretPrefix = 'NinjaOne'
    )
    $Secrets = @{
        ConnectionInfo = @{
            'AuthMode' = ('{0}AuthMode' -f $SecretPrefix)
            'URL' = ('{0}URL' -f $SecretPrefix)
            'Instance' = ('{0}Instance' -f $SecretPrefix)
            'ClientId' = ('{0}ClientId' -f $SecretPrefix)
            'ClientSecret' = ('{0}ClientSecret' -f $SecretPrefix)
            'AuthScopes' = ('{0}AuthScopes' -f $SecretPrefix)
            'RedirectURI' = ('{0}RedirectURI' -f $SecretPrefix)
            'AuthListenerPort' = ('{0}AuthListenerPort' -f $SecretPrefix)
            'UseSecretManagement' = ('{0}UseSecretManagement' -f $SecretPrefix)
            'WriteToSecretVault' = ('{0}WriteToSecretVault' -f $SecretPrefix)
            'ReadFromSecretVault' = ('{0}ReadFromSecretVault' -f $SecretPrefix)
            'VaultName' = ('{0}VaultName' -f $SecretPrefix)
        }
        AuthenticationInfo = @{
            'Type' = ('{0}Type' -f $SecretPrefix)
            'Access' = ('{0}Access' -f $SecretPrefix)
            'Expires' = ('{0}Expires' -f $SecretPrefix)
            'Refresh' = ('{0}Refresh' -f $SecretPrefix)
        }
    }
    # Setup the the script scoped variables for the connection and authentication information.
    if ($null -eq $Script:NRAPIConnectionInformation) { $Script:NRAPIConnectionInformation = @{} }
    if ($null -eq $Script:NRAPIAuthenticationInformation) { $Script:NRAPIAuthenticationInformation = @{} }
    # Retrieve the connection information from the secret vault.
    foreach ($ConnectionSecret in $Secrets.ConnectionInfo.GetEnumerator()) {
        Write-Verbose ('Processing secret {0} for vault retrieval.' -f $ConnectionSecret.Key)
        $SecretName = $ConnectionSecret.Key
        $SecretValue = Get-Secret -Name $SecretName -Vault $VaultName -ErrorAction SilentlyContinue
        if ($null -eq $SecretValue) {
            Write-Verbose ('Secret {0} is null. Skipping.' -f $SecretName)
            continue
        }
        Write-Verbose ('Secret {0} retrieved from secret vault {1}.' -f $SecretName, $VaultName)
        $Script:NRAPIConnectionInformation.$SecretName = $SecretValue
    }
    # Retrieve the authentication information from the secret vault.
    foreach ($AuthenticationSecret in $Secrets.AuthenticationInfo.GetEnumerator()) {
        Write-Verbose ('Processing secret {0} for vault retrieval.' -f $AuthenticationSecret.Key)
        $SecretName = $AuthenticationSecret.Key
        $SecretValue = Get-Secret -Name $SecretName -Vault $VaultName -ErrorAction SilentlyContinue
        if ($null -eq $SecretValue) {
            Write-Verbose ('Secret {0} is null. Skipping.' -f $SecretName)
            continue
        }
        Write-Verbose ('Secret {0} retrieved from secret vault {1}.' -f $SecretName, $VaultName)
        $Script:NRAPIAuthenticationInformation.$SecretName = $SecretValue
    }
    # If we have the port value, convert it to an integer.
    if ($null -ne $Script:NRAPIConnectionInformation.AuthListenerPort) {
        $Script:NRAPIConnectionInformation.AuthListenerPort = [Int32]::Parse($Script:NRAPIConnectionInformation.AuthListenerPort)
    }
    # if we values for UseSecretManagement, WriteToSecretVault, and ReadFromSecretVault, convert them to booleans.
    if ($null -ne $Script:NRAPIConnectionInformation.UseSecretManagement) {
        $Script:NRAPIConnectionInformation.UseSecretManagement = [Boolean]::Parse($Script:NRAPIConnectionInformation.UseSecretManagement)
    }
    if ($null -ne $Script:NRAPIConnectionInformation.WriteToSecretVault) {
        $Script:NRAPIConnectionInformation.WriteToSecretVault = [Boolean]::Parse($Script:NRAPIConnectionInformation.WriteToSecretVault)
    }
    if ($null -ne $Script:NRAPIConnectionInformation.ReadFromSecretVault) {
        $Script:NRAPIConnectionInformation.ReadFromSecretVault = [Boolean]::Parse($Script:NRAPIConnectionInformation.ReadFromSecretVault)
    }
    # If we have the expires value, convert it to a DateTime object.
    if ($null -ne $Script:NRAPIAuthenticationInformation.Expires) {
        $Script:NRAPIAuthenticationInformation.Expires = [DateTime]::Parse($Script:NRAPIAuthenticationInformation.Expires)
    }
    # Verify we have the required connection information.
    if ([String]::IsNullOrEmpty($Script:NRAPIConnectionInformation.AuthMode)) {
        Write-Error 'NinjaOne authentication mode is not set.'
        exit 1
    }
    if ([String]::IsNullOrEmpty($Script:NRAPIConnectionInformation.URL)) {
        Write-Error 'NinjaOne URL is not set.'
        exit 1
    }
    if ([String]::IsNullOrEmpty($Script:NRAPIConnectionInformation.Instance)) {
        Write-Error 'NinjaOne instance is not set.'
        exit 1
    }
    if ([String]::IsNullOrEmpty($Script:NRAPIConnectionInformation.ClientId)) {
        Write-Error 'NinjaOne client ID is not set.'
        exit 1
    }
    if ([String]::IsNullOrEmpty($Script:NRAPIConnectionInformation.ClientSecret)) {
        Write-Error 'NinjaOne client secret is not set.'
        exit 1
    }
    if ([String]::IsNullOrEmpty($Script:NRAPIConnectionInformation.AuthScopes)) {
        Write-Error 'NinjaOne authentication scopes are not set.'
        exit 1
    }
    if ($Script:NRAPIConnectionInformation.AuthMode -eq 'Authorization Code' -and [String]::IsNullOrEmpty($Script:NRAPIConnectionInformation.RedirectURI)) {
        Write-Error 'NinjaOne redirect URI is not set.'
        exit 1
    }
    if ($Script:NRAPIConnectionInformation.AuthMode -eq 'Authorization Code' -and [String]::IsNullOrEmpty($Script:NRAPIConnectionInformation.AuthListenerPort)) {
        Write-Error 'NinjaOne authentication listener port is not set.'
        exit 1
    }
    if ($Script:NRAPIConnectionInformation.AuthMode -eq 'Token Authentication' -and [String]::IsNullOrEmpty($Script:NRAPIAuthenticationInformation.Refresh)) {
        Write-Error 'NinjaOne refresh token is not set.'
        exit 1
    }
    $Script:NRAPIConnectionInformation.UseSecretManagement = $true
    $Script:NRAPIConnectionInformation.WriteToSecretVault = $true
    $Script:NRAPIConnectionInformation.VaultName = $VaultName
    $Script:NRAPIConnectionInformation.ReadFromSecretVault = $true
}