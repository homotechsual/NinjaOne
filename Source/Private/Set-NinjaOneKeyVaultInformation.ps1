function Set-NinjaOneKeyVaultInformation {
    <#
        .SYNOPSIS
            Saves NinjaOne connection and authentication information to the given Azure Key Vault.
        .DESCRIPTION
            Handles the saving of NinjaOne connection and authentication information to the given Azure Key Vault. This function is intended to be used internally by the module and should not be called directly.
        .OUTPUTS
            [System.Void]

            Returns nothing.
    #>
    [CmdletBinding()]
    [OutputType([System.Void])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Private function - no need to support.')]
    # Suppress the PSSA warning about using ConvertTo-SecureString with -AsPlainText. There's no viable alternative.
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'No viable alternative.')]
    param(
        # The authentication mode to use.
        [String]$AuthMode,
        # The URL of the NinjaRMM instance.
        [URI]$URL,
        # The NinjaRMM instance name.
        [String]$Instance,
        # The client ID of the application.
        [String]$ClientId,
        # The client secret of the application.
        [String]$ClientSecret,
        # The port to listen on for the authentication callback.
        [Int]$AuthListenerPort,
        # The authentication scopes to request.
        [String]$AuthScopes,
        # The redirect URI to use for the authentication callback.
        [URI]$RedirectURI,
        # Use the Key Vault to store the connection information.
        [Parameter(Mandatory)]
        [Switch]$UseKeyVault,
        # The name of the Key Vault to use.
        [String]$VaultName,
        # Whether to write updated connection information to Key Vault.
        [Switch]$WriteToKeyVault,
        # The type of the authentication token.
        [String]$Type,
        # The access token to use for authentication.
        [String]$Access,
        # The refresh token to use for authentication.
        [String]$Refresh,
        # The expiration time of the access token.
        [DateTime]$Expires
    )
    # Check if the Key Vault exists.
    $KeyVault = Get-AzKeyVault -VaultName $VaultName -ErrorAction SilentlyContinue
    if ($null -eq $KeyVault) {
        Write-Error ('Key Vault {0} does not exist.' -f $VaultName)
        exit 1
    }
    # Make sure we've been told to write to Key Vault.
    if ($false -eq $WriteToKeyVault) {
        Write-Error 'WriteToKeyVault must be specified.'
        exit 1
    }
    # Write the connection information to Key Vault.
    $Secrets = @{
        'NinjaOneAuthMode' = $AuthMode
        'NinjaOneURL' = $URL
        'NinjaOneInstance' = $Instance
        'NinjaOneClientId' = $ClientId
        'NinjaOneClientSecret' = $ClientSecret
        'NinjaOneAuthListenerPort' = $AuthListenerPort
        'NinjaOneAuthScopes' = $AuthScopes
        'NinjaOneRedirectURI' = $RedirectURI
        'NinjaOneType' = $Type
        'NinjaOneAccess' = $Access
        'NinjaOneRefresh' = $Refresh
        'NinjaOneExpires' = $Expires
        'NinjaOneWriteToKeyVault' = $WriteToKeyVault.ToString()
        'NinjaOneUseKeyVault' = $UseKeyVault.ToString()
        'NinjaOneVaultName' = $VaultName
    }
    foreach ($Secret in $Secrets.GetEnumerator()) {
        Write-Verbose ('Processing secret {0} for KeyVault storage.' -f $Secret.Key)
        Write-Debug ('Secret {0} has type {1}.' -f $Secret.Key, $Secret.Value.GetType().Name)
        Write-Debug ('Secret {0} has value {1}.' -f $Secret.Key, $Secret.Value.ToString())
        $SecretName = $Secret.Key
        $SecretValue = $Secret.Value
        if ([String]::IsNullOrEmpty($SecretValue) -or ($null -eq $SecretValue)) {
            Write-Verbose ('Secret {0} is null. Skipping.' -f $SecretName)
            continue
        }
        $SecretTags = @{
            'Source' = 'NinjaOne'
        }
        $SecretValue = ConvertTo-SecureString -AsPlainText -Force -String $SecretValue
        Set-AzKeyVaultSecret -VaultName $VaultName -Name $SecretName -SecretValue $SecretValue -Tag $SecretTags -ErrorAction Stop -Verbose:$false -Debug:$false
        Write-Verbose ('Secret {0} written to KeyVault.' -f $SecretName)
    }
}