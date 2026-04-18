function Connect-NinjaOne {
	<#
		.SYNOPSIS
			Creates a new connection to a NinjaOne instance.
		.DESCRIPTION
			Creates a new connection to a NinjaOne instance and stores this in a PowerShell Session.
		.FUNCTIONALITY
			NinjaOne
		.EXAMPLE
			PS> Connect-NinjaOne -instance 'eu' -clientId 'AAaaA1aaAaAA-aaAaaA11a1A-aA' -clientSecret '00Z00zzZzzzZzZzZzZzZZZ0zZ0zzZ_0zzz0zZZzzZz0Z0ZZZzz0z0Z' -useClientAuth

			This logs into NinjaOne using the client credentials flow.
		.EXAMPLE
			PS> Connect-NinjaOne -instance 'eu' -clientId 'AAaaA1aaAaAA-aaAaaA11a1A-aA' -clientSecret '00Z00zzZzzzZzZzZzZzZZZ0zZ0zzZ_0zzz0zZZzzZz0Z0ZZZzz0z0Z' -Port 9090 -useWebAuth

			This logs into NinjaOne using the authorization code flow.
		.EXAMPLE
			PS> Connect-NinjaOne -instance 'eu' -clientId 'AAaaA1aaAaAA-aaAaaA11a1A-aA' -clientSecret '00Z00zzZzzzZzZzZzZzZZZ0zZ0zzZ_0zzz0zZZzzZz0Z0ZZZzz0z0Z' -refreshToken 'a1a11a11-aa11-11a1-a111-a1a111aaa111.11AaaAaaa11aA-AA1aaaAAA111aAaaaaA1AAAA1_AAa' -useTokenAuth

			This logs into NinjaOne using the refresh token flow.
		.EXAMPLE
			PS> Connect-NinjaOne -useSecretManagement -vaultName 'NinjaOneVault' -writeToSecretVault -instance 'eu' -clientId 'AAaaA1aaAaAA-aaAaaA11a1A-aA' -clientSecret '00Z00zzZzzzZzZzZzZzZZZ0zZ0zzZ_0zzz0zZZzzZz0Z0ZZZzz0z0Z' -useClientAuth

			This logs into NinjaOne using the client credentials flow and writes the connection information to the secret vault.
		.EXAMPLE
			PS> Connect-NinjaOne -useSecretManagement -vaultName 'NinjaOneVault' -readFromSecretVault

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
	param (
		# Use the "Authorisation Code" flow with your web browser.
		[Parameter( Mandatory, ParameterSetName = 'Authorisation Code')]
		[Parameter( ParameterSetName = 'Secret Vault Write' )]
		[Switch]$useWebAuth,
		# Use the "Token Authentication" flow - useful if you already have a refresh token.
		[Parameter( Mandatory, ParameterSetName = 'Token Authentication' )]
		[Parameter( ParameterSetName = 'Secret Vault Write' )]
		[switch]$useTokenAuth,
		# Use the "Client Credentials" flow - useful if you already have a client ID and secret.
		[Parameter( Mandatory, ParameterSetName = 'Client Credentials' )]
		[Parameter( ParameterSetName = 'Secret Vault Write' )]
		[switch]$useClientAuth,
		# The NinjaOne instance to connect to. Choose from 'eu', 'oc' or 'us'.
		[Parameter( Mandatory, ParameterSetName = 'Authorisation Code' )]
		[Parameter( Mandatory, ParameterSetName = 'Token Authentication' )]
		[Parameter( Mandatory, ParameterSetName = 'Client Credentials' )]
		[Parameter( Mandatory, ParameterSetName = 'Secret Vault Write' )]
	[ValidateSet('eu', 'oc', 'us', 'ca', 'us2', 'fed')]
		[string]$instance,
		# The Client Id for the application configured in NinjaOne.
		[Parameter( Mandatory, ParameterSetName = 'Authorisation Code' )]
		[Parameter( Mandatory, ParameterSetName = 'Token Authentication' )]
		[Parameter( Mandatory, ParameterSetName = 'Client Credentials' )]
		[Parameter( Mandatory, ParameterSetName = 'Secret Vault Write' )]
		[String]$clientId,
		# The Client Secret for the application configured in NinjaOne.
		[Parameter( Mandatory, ParameterSetName = 'Authorisation Code' )]
		[Parameter( Mandatory, ParameterSetName = 'Token Authentication' )]
		[Parameter( Mandatory, ParameterSetName = 'Client Credentials' )]
		[Parameter( Mandatory, ParameterSetName = 'Secret Vault Write' )]
		[String]$clientSecret,
		# The API scopes to request, if this isn't passed the scope is assumed to be "all". Pass a string or array of strings. Limited by the scopes granted to the application in NinjaOne.
		[Parameter( ParameterSetName = 'Authorisation Code' )]
		[Parameter( ParameterSetName = 'Token Authentication' )]
		[Parameter( ParameterSetName = 'Client Credentials' )]
		[Parameter( ParameterSetName = 'Secret Vault Write' )]
		[ValidateSet('monitoring', 'management', 'control', 'offline_access')]
		[String[]]$scopes,
		# The redirect URI to use. If not set defaults to 'http://localhost'. Should be a full URI e.g. https://redirect.example.uk:9090/auth
		[Parameter( ParameterSetName = 'Authorisation Code' )]
		[Parameter( ParameterSetName = 'Secret Vault Write' )]
		[URI]$redirectURL,
		# The port to use for the redirect URI. Must match with the configuration set in NinjaOne. If not set defaults to '9090'.
		[Parameter( ParameterSetName = 'Authorisation Code' )]
		[Parameter( ParameterSetName = 'Secret Vault Write' )]
		[Int]$port = 9090,
		# The refresh token to use for "Token Authentication" flow.
		[Parameter( ParameterSetName = 'Token Authentication' )]
		[Parameter( ParameterSetName = 'Secret Vault Write' )]
		[String]$refreshToken,
		# Output the tokens - useful when using "Authorisation Code" flow - to use with "Token Authentication" flow.
		[Parameter( ParameterSetName = 'Authorisation Code' )]
		[Parameter( ParameterSetName = 'Token Authentication' )]
		[Parameter( ParameterSetName = 'Client Credentials' )]
		[Switch]$showTokens,
		# Use the secret management module to retrieve credentials and store tokens. Check the docs on setting up the secret management module at https://docs.homotechsual.dev/common/secretmanagement.
		[Parameter( ParameterSetName = 'Authorisation Code' )]
		[Parameter( ParameterSetName = 'Token Authentication' )]
		[Parameter( ParameterSetName = 'Client Credentials' )]
		[Parameter( Mandatory, ParameterSetName = 'Secret Vault Write' )]
		[Parameter( Mandatory, ParameterSetName = 'Secret Vault Read' )]
		[Switch]$useSecretManagement,
		# The name of the secret vault to use.
		[Parameter( ParameterSetName = 'Authorisation Code' )]
		[Parameter( ParameterSetName = 'Token Authentication' )]
		[Parameter( ParameterSetName = 'Client Credentials' )]
		[Parameter( Mandatory, ParameterSetName = 'Secret Vault Write' )]
		[Parameter( Mandatory, ParameterSetName = 'Secret Vault Read' )]
		[String]$vaultName,
		# Write updated credentials to secret management vault.
		[Parameter( ParameterSetName = 'Authorisation Code' )]
		[Parameter( ParameterSetName = 'Token Authentication' )]
		[Parameter( ParameterSetName = 'Client Credentials' )]
		[Parameter( Mandatory, ParameterSetName = 'Secret Vault Write' )]
		[Parameter( ParameterSetName = 'Secret Vault Read')]
		[Switch]$writeToSecretVault,
		# Read the authentication information from secret management vault.
		[Parameter( ParameterSetName = 'Secret Vault Read' )]
		[Switch]$readFromSecretVault,
		# The prefix to add to the name of the secrets stored in the secret vault.
		[Parameter( ParameterSetName = 'Secret Vault Write' )]
		[Parameter( ParameterSetName = 'Secret Vault Read' )]
		[String]$secretPrefix = 'NinjaOne',
		# Automatically parse date/time values in API responses.
		[Parameter( ParameterSetName = 'Authorisation Code' )]
		[Parameter( ParameterSetName = 'Token Authentication' )]
		[Parameter( ParameterSetName = 'Client Credentials' )]
		[Parameter( ParameterSetName = 'Secret Vault Write' )]
		[Parameter( ParameterSetName = 'Secret Vault Read' )]
		[Switch]$parseDateTimes
	)
	process {
		# Run the pre-flight check.
		Invoke-NinjaOnePreFlightCheck -SkipConnectionChecks
		# Test for secret management module.
		if ($useSecretManagement -or $Script:NRAPIConnectionInformation.UseSecretManagement) {
			if (-not (Get-Module -Name 'Microsoft.PowerShell.SecretManagement' -ListAvailable)) {
				Write-Error 'Secret management module not installed, please install the module and try again.'
				exit 1
			}
			if (-not (Get-SecretVault)) {
				Write-Error 'No secret vaults found, please create a secret vault and try again.'
				exit 1
			}
			if ($readFromSecretVault -or $Script:NRAPIConnectionInformation.ReadFromSecretVault) {
				Write-Verbose 'Reading authentication information from secret vault.'
				Get-NinjaOneSecrets -vaultName $vaultName
			}
		}
		# Set the default scopes if they're not passed.
		if ($useClientAuth -and $null -eq $scopes) {
			Write-Verbose 'Setting default scopes for client credentials auth.'
			$scopes = @('monitoring', 'management', 'control')
		} elseif (($useWebAuth -or $useTokenAuth) -and $null -eq $scopes) {
			Write-Verbose 'Setting default scopes for authorisation code or token auth.'
			$scopes = @('monitoring', 'management', 'control', 'offline_access')
		}
		# Convert scopes to space separated string if it's an array.
		if ($scopes -is [System.Array]) {
			Write-Verbose ('Scopes are an array, converting to space separated string.')
			$AuthScopes = $scopes -join ' '
		} else {
			Write-Verbose ('Scopes are a string, using as is.')
			$AuthScopes = $scopes
		}
		# Get the NinjaOne instance URL.
		if ($instance) {
			Write-Verbose "Using instance $($instance) with URL $($Script:NRAPIInstances[$instance])"
			$URL = $Script:NRAPIInstances[$instance]
		}
		# Generate a GUID to serve as our state validator.
		$GUID = ([GUID]::NewGuid()).Guid
		# Build the redirect URI, if we need one.
		if ($redirectURL) {
			$RedirectURI = [System.UriBuilder]$redirectURL
		} else {
			$RedirectURI = New-Object System.UriBuilder -ArgumentList 'http', 'localhost', $port
		}
		# Determine the authentication mode.
		if ($useWebAuth -and $scopes -notcontains 'offline_access') {
			$AuthMode = 'Authorisation Code'
		} elseif ($useTokenAuth -or ($useWebAuth -and $scopes -contains 'offline_access')) {
			$AuthMode = 'Token Authentication'
		} elseif ($useClientAuth) {
			$AuthMode = 'Client Credentials'
		}
		# Build a script-scoped variable to hold the connection information.
		if ($null -eq $Script:NRAPIConnectionInformation) {
			$ConnectionInformation = @{
				AuthMode = $AuthMode
				URL = $URL
				Instance = $instance
				ClientId = $clientId
				ClientSecret = $clientSecret
				AuthListenerPort = $port
				AuthScopes = $AuthScopes
				RedirectURI = $RedirectURI
				UseSecretManagement = $useSecretManagement
				VaultName = $vaultName
				WriteToSecretVault = $writeToSecretVault
				SecretPrefix = $secretPrefix
			}
			Set-Variable -Name 'NRAPIConnectionInformation' -Value $ConnectionInformation -Visibility Private -Scope Script -Force
		}
		# Set the ParseDateTimes module variable based on the parameter
		if ($parseDateTimes) {
			$Script:ParseDateTimes = $true
			Write-Verbose 'Automatic date/time parsing enabled.'
		}
		Write-Verbose "Connection information set to: $($Script:NRAPIConnectionInformation | Format-List | Out-String)"
		if ($null -eq $Script:NRAPIAuthenticationInformation) {
			$AuthenticationInformation = [HashTable]@{}
			# Set a script-scoped variable to hold authentication information.
			Set-Variable -Name 'NRAPIAuthenticationInformation' -Value $AuthenticationInformation -Visibility Private -Scope Script -Force
		}
		if ($Script:NRAPIConnectionInformation.AuthMode -eq 'Token Authentication' -and $null -eq $useTokenAuth) {
			$useTokenAuth = $true
		}
		if ($Script:NRAPIConnectionInformation.AuthMode -eq 'Client Credentials' -and $null -eq $useClientAuth) {
			$useClientAuth = $true
		}
		if ($Script:NRAPIConnectionInformation.AuthMode -eq 'Authorisation Code' -and $null -eq $useWebAuth) {
			$useWebAuth = $true
		}
		if ($useWebAuth) {
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
			$AuthRequestURI.Path = 'ws/oauth/authorize'
			$AuthRequestURI.Query = $AuthRequestQuery.ToString()
			Write-Verbose "Authentication request query string is $($AuthRequestQuery.ToString())"
			try {
				$OAuthListenerParams = @{
					OpenURI = $AuthRequestURI
				}
				if ($VerbosePreference -eq 'continue') {
					$OAuthListenerParams.Verbose = $true
				}
				if ($DebugPreference -eq 'continue') {
					$OAuthListenerParams.Debug = $true
				}
				$OAuthListenerResponse = Start-OAuthHTTPListener @OAuthListenerParams
				$Script:NRAPIAuthenticationInformation.Code = $OAuthListenerResponse.Code
			} catch {
				New-NinjaOneError -ErrorRecord $_
			}
		}
		if (($useTokenAuth) -or ($OAuthListenerResponse.GotAuthorisationCode) -or ($useClientAuth)) {
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
				} elseif ($useTokenAuth) {
					Write-Verbose 'Using refresh token.'
					$TokenRequestBody = @{
						grant_type = 'refresh_token'
						client_id = $Script:NRAPIConnectionInformation.ClientId
						client_secret = $Script:NRAPIConnectionInformation.ClientSecret
						refresh_token = $refreshToken
						scope = $Script:NRAPIConnectionInformation.AuthScopes
					}
				} elseif ($useClientAuth) {
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
				$TokenRequestUri.Path = 'ws/oauth/token'
				Write-Verbose "Making token request to $($TokenRequestUri.ToString())"
				$TokenRequestParams = @{
					Uri = $TokenRequestUri.ToString()
					Method = 'POST'
					Body = $TokenRequestBody
					ContentType = 'application/x-www-form-urlencoded'
				}
				if ($PSVersionTable.PSVersion.Major -eq 5) {
					$TokenRequestParams.UseBasicParsing = $true
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
				if ($showTokens) {
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
				ParseDateTimes = $Script:ParseDateTimes
			}
			Write-Verbose 'Using secret management to store credentials.'
			Set-NinjaOneSecrets @SecretManagementParams
		}
	}
}
