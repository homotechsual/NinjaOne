function Connect-NinjaOne {
    <#
        .SYNOPSIS
            Creates a new connection to a NinjaOne instance.
        .DESCRIPTION
            Creates a new connection to a NinjaOne instance and stores this in a PowerShell Session.
        .FUNCTIONALITY
            NinjaOne
        .EXAMPLE
            PS> Connect-NinjaOne -Instance 'eu' -ClientId 'AAaaA1aaAaAA-aaAaaA11a1A-aA' -ClientSecret '00Z00zzZzzzZzZzZzZzZZZ0zZ0zzZ_0zzz0zZZzzZz0Z0ZZZzz0z0Z' -UseClientAuth

            This logs into NinjaOne using the client credentials flow.
        .EXAMPLE
            PS> Connect-NinjaOne -Instance 'eu' -ClientId 'AAaaA1aaAaAA-aaAaaA11a1A-aA' -ClientSecret '00Z00zzZzzzZzZzZzZzZZZ0zZ0zzZ_0zzz0zZZzzZz0Z0ZZZzz0z0Z' -Port 9090 -UseWebAuth

            This logs into NinjaOne using the authorization code flow.
        .EXAMPLE
            PS> Connect-NinjaOne -Instance 'eu' -ClientId 'AAaaA1aaAaAA-aaAaaA11a1A-aA' -ClientSecret '00Z00zzZzzzZzZzZzZzZZZ0zZ0zzZ_0zzz0zZZzzZz0Z0ZZZzz0z0Z' -RefreshToken 'a1a11a11-aa11-11a1-a111-a1a111aaa111.11AaaAaaa11aA-AA1aaaAAA111aAaaaaA1AAAA1_AAa' -UseTokenAuth

            This logs into NinjaOne using the refresh token flow.
        .EXAMPLE
            PS> Connect-NinjaOne -UseSecretManagement -VaultName 'NinjaOneVault' -WriteToSecretVault -Instance 'eu' -ClientId 'AAaaA1aaAaAA-aaAaaA11a1A-aA' -ClientSecret '00Z00zzZzzzZzZzZzZzZZZ0zZ0zzZ_0zzz0zZZzzZz0Z0ZZZzz0z0Z' -UseClientAuth

            This logs into NinjaOne using the client credentials flow and writes the connection information to the secret vault.
        .EXAMPLE
            PS> Connect-NinjaOne -UseSecretManagement -VaultName 'NinjaOneVault' -ReadFromSecretVault

            This reads the connection information from the secret vault.
        .OUTPUTS
            Sets two script-scoped variables to hold connection and authentication information.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Connect/ninjaone
    #>
    [CmdletBinding( DefaultParameterSetName = 'Authorisation Code' )]
    [OutputType([System.Void])]
    [Alias('cno')]
    [MetadataAttribute('IGNORE')]
    Param (
        # Use the "Authorisation Code" flow with your web browser.
        [Parameter( Mandatory, ParameterSetName = 'Authorisation Code')]
        [Parameter( ParameterSetName = 'Secret Vault Write' )]
        [Switch]$UseWebAuth,
        # Use the "Token Authentication" flow - useful if you already have a refresh token.
        [Parameter( Mandatory, ParameterSetName = 'Token Authentication' )]
        [Parameter( ParameterSetName = 'Secret Vault Write' )]
        [switch]$UseTokenAuth,
        # Use the "Client Credentials" flow - useful if you already have a client ID and secret.
        [Parameter( Mandatory, ParameterSetName = 'Client Credentials' )]
        [Parameter( ParameterSetName = 'Secret Vault Write' )]
        [switch]$UseClientAuth,
        # The NinjaOne instance to connect to. Choose from 'eu', 'oc' or 'us'.
        [Parameter( Mandatory, ParameterSetName = 'Authorisation Code' )]
        [Parameter( Mandatory, ParameterSetName = 'Token Authentication' )]
        [Parameter( Mandatory, ParameterSetName = 'Client Credentials' )]
        [Parameter( Mandatory, ParameterSetName = 'Secret Vault Write' )]
        [ValidateSet('eu', 'oc', 'us', 'ca', 'us2')]
        [string]$Instance,
        # The Client Id for the application configured in NinjaOne.
        [Parameter( Mandatory, ParameterSetName = 'Authorisation Code' )]
        [Parameter( Mandatory, ParameterSetName = 'Token Authentication' )]
        [Parameter( Mandatory, ParameterSetName = 'Client Credentials' )]
        [Parameter( Mandatory, ParameterSetName = 'Secret Vault Write' )]
        [String]$ClientId,
        # The Client Secret for the application configured in NinjaOne.
        [Parameter( Mandatory, ParameterSetName = 'Authorisation Code' )]
        [Parameter( Mandatory, ParameterSetName = 'Token Authentication' )]
        [Parameter( Mandatory, ParameterSetName = 'Client Credentials' )]
        [Parameter( Mandatory, ParameterSetName = 'Secret Vault Write' )]
        [String]$ClientSecret,
        # The API scopes to request, if this isn't passed the scope is assumed to be "all". Pass a string or array of strings. Limited by the scopes granted to the application in NinjaOne.
        [Parameter( ParameterSetName = 'Authorisation Code' )]
        [Parameter( ParameterSetName = 'Token Authentication' )]
        [Parameter( ParameterSetName = 'Client Credentials' )]
        [Parameter( ParameterSetName = 'Secret Vault Write' )]
        [ValidateSet('monitoring', 'management', 'control', 'offline_access')]
        [String[]]$Scopes,
        # The redirect URI to use. If not set defaults to 'http://localhost'. Should be a full URI e.g. https://redirect.example.uk:9090/auth
        [Parameter( ParameterSetName = 'Authorisation Code' )]
        [Parameter( ParameterSetName = 'Secret Vault Write' )]
        [URI]$RedirectURL,
        # The port to use for the redirect URI. Must match with the configuration set in NinjaOne. If not set defaults to '9090'.
        [Parameter( ParameterSetName = 'Authorisation Code' )]
        [Parameter( ParameterSetName = 'Secret Vault Write' )]
        [Int]$Port = 9090,
        # The refresh token to use for "Token Authentication" flow.
        [Parameter( ParameterSetName = 'Token Authentication' )]
        [Parameter( ParameterSetName = 'Secret Vault Write' )]
        [String]$RefreshToken,
        # Output the tokens - useful when using "Authorisation Code" flow - to use with "Token Authentication" flow.
        [Parameter( ParameterSetName = 'Authorisation Code' )]
        [Parameter( ParameterSetName = 'Token Authentication' )]
        [Parameter( ParameterSetName = 'Client Credentials' )]
        [Switch]$ShowTokens,
        # Use the secret management module to retrieve credentials and store tokens. Check the docs on setting up the secret management module at https://docs.homotechsual.dev/common/secretmanagement.
        [Parameter( ParameterSetName = 'Authorisation Code' )]
        [Parameter( ParameterSetName = 'Token Authentication' )]
        [Parameter( ParameterSetName = 'Client Credentials' )]
        [Parameter( Mandatory, ParameterSetName = 'Secret Vault Write' )]
        [Parameter( Mandatory, ParameterSetName = 'Secret Vault Read' )]
        [Switch]$UseSecretManagement,
        # The name of the secret vault to use.
        [Parameter( ParameterSetName = 'Authorisation Code' )]
        [Parameter( ParameterSetName = 'Token Authentication' )]
        [Parameter( ParameterSetName = 'Client Credentials' )]
        [Parameter( Mandatory, ParameterSetName = 'Secret Vault Write' )]
        [Parameter( Mandatory, ParameterSetName = 'Secret Vault Read' )]
        [String]$VaultName,
        # Write updated credentials to secret management vault.
        [Parameter( ParameterSetName = 'Authorisation Code' )]
        [Parameter( ParameterSetName = 'Token Authentication' )]
        [Parameter( ParameterSetName = 'Client Credentials' )]
        [Parameter( Mandatory, ParameterSetName = 'Secret Vault Write' )]
        [Parameter( ParameterSetName = 'Secret Vault Read')]
        [Switch]$WriteToSecretVault,
        # Read the authentication information from secret management vault.
        [Parameter( ParameterSetName = 'Secret Vault Read' )]
        [Switch]$ReadFromSecretVault,
        # The prefix to add to the name of the secrets stored in the secret vault.
        [Parameter( ParameterSetName = 'Secret Vault Write' )]
        [Parameter( ParameterSetName = 'Secret Vault Read' )]
        [String]$SecretPrefix = 'NinjaOne'
    )
    process {
        # Run the pre-flight check.
        Invoke-NinjaOnePreFlightCheck -SkipConnectionChecks
        # Test for secret management module.
        if ($UseSecretManagement -or $Script:NRAPIConnectionInformation.UseSecretManagement) {
            if (-not (Get-Module -Name 'Microsoft.PowerShell.SecretManagement' -ListAvailable)) {
                Write-Error 'Secret management module not installed, please install the module and try again.'
                exit 1
            }
            if (-not (Get-SecretVault)) {
                Write-Error 'No secret vaults found, please create a secret vault and try again.'
                exit 1
            }
            if ($ReadFromSecretVault -or $Script:NRAPIConnectionInformation.ReadFromSecretVault) {
                Write-Verbose 'Reading authentication information from secret vault.'
                Get-NinjaOneSecrets -VaultName $VaultName
            }
        }
        # Set the default scopes if they're not passed.
        if ($UseClientAuth -and $null -eq $Scopes) {
            Write-Verbose 'Setting default scopes for client credentials auth.'
            $Scopes = @('monitoring', 'management', 'control')
        } elseif (($UseWebAuth -or $UseTokenAuth) -and $null -eq $Scopes) {
            Write-Verbose 'Setting default scopes for authorisation code or token auth.'
            $Scopes = @('monitoring', 'management', 'control', 'offline_access')
        }
        # Convert scopes to space separated string if it's an array.
        if ($Scopes -is [System.Array]) {
            Write-Verbose ('Scopes are an array, converting to space separated string.')
            $AuthScopes = $Scopes -Join ' '
        } else {
            Write-Verbose ('Scopes are a string, using as is.')
            $AuthScopes = $Scopes
        }
        # Get the NinjaOne instance URL.
        if ($Instance) {
            Write-Verbose "Using instance $($Instance) with URL $($Script:NRAPIInstances[$Instance])"
            $URL = $Script:NRAPIInstances[$Instance]
        }
        # Generate a GUID to serve as our state validator.
        $GUID = ([GUID]::NewGuid()).Guid
        # Build the redirect URI, if we need one.
        if ($RedirectURL) {
            $RedirectURI = [System.UriBuilder]$RedirectURL
        } else {
            $RedirectURI = New-Object System.UriBuilder -ArgumentList 'http', 'localhost', $Port
        }
        # Determine the authentication mode.
        if ($UseWebAuth -and $Scopes -notcontains 'offline_access') {
            $AuthMode = 'Authorisation Code'
        } elseif ($UseTokenAuth -or ($UseWebAuth -and $Scopes -contains 'offline_access')) {
            $AuthMode = 'Token Authentication'
        } elseif ($UseClientAuth) {
            $AuthMode = 'Client Credentials'
        }
        # Build a script-scoped variable to hold the connection information.
        if ($null -eq $Script:NRAPIConnectionInformation) {  
            $ConnectionInformation = @{
                AuthMode = $AuthMode
                URL = $URL
                Instance = $Instance
                ClientId = $ClientId
                ClientSecret = $ClientSecret
                AuthListenerPort = $Port
                AuthScopes = $AuthScopes
                RedirectURI = $RedirectURI
                UseSecretManagement = $UseSecretManagement
                VaultName = $VaultName
                WriteToSecretVault = $WriteToSecretVault
                SecretPrefix = $SecretPrefix
            }
            Set-Variable -Name 'NRAPIConnectionInformation' -Value $ConnectionInformation -Visibility Private -Scope Script -Force
        }
        Write-Verbose "Connection information set to: $($Script:NRAPIConnectionInformation | Format-List | Out-String)"
        if ($null -eq $Script:NRAPIAuthenticationInformation) {
            $AuthenticationInformation = [HashTable]@{}
            # Set a script-scoped variable to hold authentication information.
            Set-Variable -Name 'NRAPIAuthenticationInformation' -Value $AuthenticationInformation -Visibility Private -Scope Script -Force
        }
        if ($Script.NRAPIConnectionInformation.AuthMode -eq 'Token Authentication' -and $null -eq $UseTokenAuth) {
            $UseTokenAuth = $true
        }
        if ($Script.NRAPIConnectionInformation.AuthMode -eq 'Client Credentials' -and $null -eq $UseClientAuth) {
            $UseClientAuth = $true
        }
        if ($Script.NRAPIConnectionInformation.AuthMode -eq 'Authorisation Code' -and $null -eq $UseWebAuth) {
            $UseWebAuth = $true
        }
        if ($UseWebAuth) {
            # NinjaOne authorisation request query params.
            $AuthRequestParams = @{
                response_type = 'code'
                client_id = $Script:NRAPIConnectionInformation.ClientId
                client_secret = $Script:NRAPIConnectionInformation.ClientSecret
                redirect_uri = $Script:NRAPIConnectionInformation.RedirectURI.ToString()
                state = $GUID
            }
            if ($Script:NRAPIConnectionInformation.AuthScopes) {
                $AuthRequestParams.scope = $Script:NRAPIConnectionInformation.AuthScopes
            }
            # Build the authentication URI.
            # Start with the query string.
            $AuthRequestQuery = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
            $AuthRequestParams.GetEnumerator() | ForEach-Object {
                $AuthRequestQuery.Add($_.Key, $_.Value)
            }
            # Now the authentication URI
            $AuthRequestURI = [System.UriBuilder]$URL
            $AuthRequestURI.Path = 'oauth/authorize'
            $AuthRequestURI.Query = $AuthRequestQuery.ToString()
            Write-Verbose "Authentication request query string is $($AuthRequestQuery.ToString())"
            try {
                $OAuthListenerParams = @{
                    OpenURI = $AuthRequestURI
                }
                if ($VerbosePreference = 'Continue') {
                    $OAuthListenerParams.Verbose = $true
                }
                if ($DebugPreference = 'Continue') {
                    $OAuthListenerParams.Debug = $true
                }
                $OAuthListenerResponse = Start-OAuthHTTPListener @OAuthListenerParams
                $Script:NRAPIAuthenticationInformation.Code = $OAuthListenerResponse.Code
            } catch {
                New-NinjaOneError -ErrorRecord $_
            }
        }
        if (($UseTokenAuth) -or ($OAuthListenerResponse.GotAuthorisationCode) -or ($UseClientAuth)) {
            Write-Verbose 'Getting authentication token.'
            try {
                if ($OAuthListenerResponse.GotAuthorisationCode) {
                    Write-Verbose 'Using token authentication.'
                    $TokenRequestBody = @{
                        grant_type = 'authorization_code'
                        client_id = $Script:NRAPIConnectionInformation.ClientId
                        client_secret = $Script:NRAPIConnectionInformation.ClientSecret
                        code = $Script:NRAPIAuthenticationInformation.Code
                        redirect_uri = $Script:NRAPIConnectionInformation.RedirectURI.toString()
                        scope = $Script:NRAPIConnectionInformation.AuthScopes
                    }
                } elseif ($UseTokenAuth) {
                    Write-Verbose 'Using refresh token.'
                    $TokenRequestBody = @{
                        grant_type = 'refresh_token'
                        client_id = $Script:NRAPIConnectionInformation.ClientId
                        client_secret = $Script:NRAPIConnectionInformation.ClientSecret
                        refresh_token = $RefreshToken
                        scope = $Script:NRAPIConnectionInformation.AuthScopes
                    }
                } elseif ($UseClientAuth) {
                    Write-Verbose 'Using client authentication.'
                    $TokenRequestBody = @{
                        grant_type = 'client_credentials'
                        client_id = $Script:NRAPIConnectionInformation.ClientId
                        client_secret = $Script:NRAPIConnectionInformation.ClientSecret
                        redirect_uri = $Script:NRAPIConnectionInformation.RedirectURI.toString()
                        scope = $Script:NRAPIConnectionInformation.AuthScopes
                    }
                }
                Write-Verbose "Token request body is $($TokenRequestBody | Format-List | Out-String)"
                # Using our authorisation code or refresh token let's get an auth token.
                $TokenRequestUri = [System.UriBuilder]$URL
                $TokenRequestUri.Path = 'oauth/token'
                Write-Verbose "Making token request to $($TokenRequestUri.ToString())"
                $TokenRequestParams = @{
                    Uri = $TokenRequestUri.ToString()
                    Method = 'POST'
                    Body = $TokenRequestBody
                    ContentType = 'application/x-www-form-urlencoded'
                }
                $TokenResult = Invoke-WebRequest @TokenRequestParams
                $TokenPayload = $TokenResult.Content | ConvertFrom-Json
                Write-Verbose "Token payload is $($TokenPayload | Format-List | Out-String)"
                # Update our script-scoped NRAPIAuthenticationInformation variable with the token.
                $Script:NRAPIAuthenticationInformation.Type = $TokenPayload.token_type
                $Script:NRAPIAuthenticationInformation.Access = $TokenPayload.access_token
                $Script:NRAPIAuthenticationInformation.Expires = Get-TokenExpiry -ExpiresIn $TokenPayload.expires_in
                $Script:NRAPIAuthenticationInformation.Refresh = $TokenPayload.refresh_token
                Write-Verbose 'Got authentication token information from NinjaOne.'
                Write-Verbose "Authentication information set to: $($Script:NRAPIAuthenticationInformation | Format-List | Out-String)"
                if ($ShowTokens) {
                    Write-Output '================ Auth Tokens ================'
                    Write-Output $($Script:NRAPIAuthenticationInformation | Format-Table -AutoSize)
                    Write-Output '       SAVE THESE IN A SECURE LOCATION       '
                }
            } catch {
                throw
            }
        }
        # If we're using secret management, store the authentication information we need.
        if ($Script:NRAPIConnectionInformation.UseSecretManagement -and $Script:NRAPIConnectionInformation.WriteToSecretVault) {
            $SecretManagementParams = @{
                AuthMode = $Script:NRAPIConnectionInformation.AuthMode
                URL = $Script:NRAPIConnectionInformation.URL
                Instance = $Script:NRAPIConnectionInformation.Instance
                ClientId = $Script:NRAPIConnectionInformation.ClientId
                ClientSecret = $Script:NRAPIConnectionInformation.ClientSecret
                AuthListenerPort = $Script:NRAPIConnectionInformation.AuthListenerPort
                AuthScopes = $Script:NRAPIConnectionInformation.AuthScopes
                RedirectURI = $Script:NRAPIConnectionInformation.RedirectURI.ToString()
                UseSecretManagement = $Script:NRAPIConnectionInformation.UseSecretManagement
                VaultName = $Script:NRAPIConnectionInformation.VaultName
                WriteToSecretVault = $Script:NRAPIConnectionInformation.WriteToSecretVault
                ReadFromSecretVault = $Script:NRAPIConnectionInformation.ReadFromSecretVault
                Type = $Script:NRAPIAuthenticationInformation.Type
                Access = $Script:NRAPIAuthenticationInformation.Access
                Expires = $Script:NRAPIAuthenticationInformation.Expires
                Refresh = $Script:NRAPIAuthenticationInformation.Refresh
                SecretPrefix = $Script:NRAPIConnectionInformation.SecretPrefix
            }
            Write-Verbose 'Using secret management to store credentials.'
            Set-NinjaOneSecrets @SecretManagementParams
        }
    }
}