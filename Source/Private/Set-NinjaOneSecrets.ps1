function Set-NinjaOneSecrets {
	<#
		.SYNOPSIS
			Saves NinjaOne connection and authentication using the SecretManagement module.
		.DESCRIPTION
			Handles the saving of NinjaOne connection and authentication information using the SecretManagement module. This function is intended to be used internally by the module and should not be called directly.
		.OUTPUTS
			[System.Void]

			Returns nothing.
	#>
	[CmdletBinding()]
	[OutputType([System.Void])]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Private function - no need to support.')]
	# Suppress the PSSA warning about using ConvertTo-SecureString with -AsPlainText. There's no viable alternative.
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'No viable alternative.')]
	# Suppress the PSSA warning about invoking empty members which is caused by our use of dynamic member names. This is a false positive.
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidInvokingEmptyMembers', '', Justification = 'False positive.')]
	# Suppress the PSSA warning about unused parameters. Parameters are accepted for API consistency but not used directly.
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Parameters accepted for API consistency but populated from script variables.')]
	param(
		# The authentication mode to use.
		[String]$authMode,
		# The URL of the NinjaRMM instance.
		[URI]$uRL,
		# The NinjaRMM instance name.
		[String]$instance,
		# The client ID of the application.
		[String]$clientId,
		# The client secret of the application.
		[String]$clientSecret,
		# The port to listen on for the authentication callback.
		[Int]$authListenerPort,
		# The authentication scopes to request.
		[String]$authScopes,
		# The redirect URI to use for the authentication callback.
		[URI]$redirectURI,
		# Use the Key Vault to store the connection information.
		[Parameter(Mandatory)]
		[Switch]$useSecretManagement,
		# The name of the secret vault to use.
		[String]$vaultName,
		# Whether to write updated connection information to the secret vault.
		[Switch]$writeToSecretVault,
		# Whether to read the connection information from the secret vault.
		[Switch]$readFromSecretVault,
		# The type of the authentication token.
		[String]$type,
		# The access token to use for authentication.
		[String]$access,
		# The expiration time of the access token.
		[DateTime]$expires,
		# The refresh token to use for authentication.
		[String]$refresh,
		# The prefix to use for the secret names.
		[String]$secretPrefix = 'NinjaOne',
		# Whether to automatically parse date/time values.
		[Boolean]$parseDateTimes
	)
	# Check if the secret vault exists.
	$SecretVault = Get-SecretVault -Name $vaultName -ErrorAction SilentlyContinue
	if ($null -eq $SecretVault) {
		Write-Error ('Secret vault {0} does not exist.' -f $vaultName)
		exit 1
	}
	# Make sure we've been told to write to the secret vault.
	if ($false -eq $writeToSecretVault) {
		Write-Error 'WriteToSecretVault must be specified.'
		exit 1
	}
	# Write the connection information to the secret vault.
	$Secrets = [Hashtable]@{}
	if ($null -ne $Script:NRAPIConnectionInformation.AuthMode) {
		$Secrets.('{0}AuthMode' -f $secretPrefix) = $Script:NRAPIConnectionInformation.AuthMode
	}
	if ($null -ne $Script:NRAPIConnectionInformation.URL) {
		$Secrets.('{0}URL' -f $secretPrefix) = $Script:NRAPIConnectionInformation.URL
	}
	if ($null -ne $Script:NRAPIConnectionInformation.Instance) {
		$Secrets.('{0}Instance' -f $secretPrefix) = $Script:NRAPIConnectionInformation.Instance
	}
	if ($null -ne $Script:NRAPIConnectionInformation.ClientId) {
		$Secrets.('{0}ClientId' -f $secretPrefix) = $Script:NRAPIConnectionInformation.ClientId
	}
	if ($null -ne $Script:NRAPIConnectionInformation.ClientSecret) {
		$Secrets.('{0}ClientSecret' -f $secretPrefix) = $Script:NRAPIConnectionInformation.ClientSecret
	}
	if ($null -ne $Script:NRAPIConnectionInformation.AuthScopes) {
		$Secrets.('{0}AuthScopes' -f $secretPrefix) = $Script:NRAPIConnectionInformation.AuthScopes
	}
	if ($null -ne $Script:NRAPIConnectionInformation.RedirectURI) {
		$Secrets.('{0}RedirectURI' -f $secretPrefix) = $Script:NRAPIConnectionInformation.RedirectURI.ToString()
	}
	if ($null -ne $Script:NRAPIConnectionInformation.AuthListenerPort) {
		$Secrets.('{0}AuthListenerPort' -f $secretPrefix) = $Script:NRAPIConnectionInformation.AuthListenerPort.ToString()
	}
	if ($null -ne $Script:NRAPIAuthenticationInformation.Type) {
		$Secrets.('{0}Type' -f $secretPrefix) = $Script:NRAPIAuthenticationInformation.Type
	}
	if ($null -ne $Script:NRAPIAuthenticationInformation.Access) {
		$Secrets.('{0}Access' -f $secretPrefix) = $Script:NRAPIAuthenticationInformation.Access
	}
	if ($null -ne $Script:NRAPIAuthenticationInformation.Expires) {
		$Secrets.('{0}Expires' -f $secretPrefix) = $Script:NRAPIAuthenticationInformation.Expires.ToString()
	}
	if ($null -ne $Script:NRAPIAuthenticationInformation.Refresh) {
		$Secrets.('{0}Refresh' -f $secretPrefix) = $Script:NRAPIAuthenticationInformation.Refresh
	}
	if ($null -ne $Script:NRAPIConnectionInformation.UseSecretManagement) {
		$Secrets.('{0}UseSecretManagement' -f $secretPrefix) = $Script:NRAPIConnectionInformation.UseSecretManagement.ToString()
	}
	if ($null -ne $Script:NRAPIConnectionInformation.WriteToSecretVault) {
		$Secrets.('{0}WriteToSecretVault' -f $secretPrefix) = $Script:NRAPIConnectionInformation.WriteToSecretVault.ToString()
	}
	if ($null -ne $Script:NRAPIConnectionInformation.ReadFromSecretVault) {
		$Secrets.('{0}ReadFromSecretVault' -f $secretPrefix) = $Script:NRAPIConnectionInformation.ReadFromSecretVault.ToString()
	}
	if ($null -ne $Script:NRAPIConnectionInformation.VaultName) {
		$Secrets.('{0}VaultName' -f $secretPrefix) = $Script:NRAPIConnectionInformation.VaultName
	}
	if ($null -ne $Script:ParseDateTimes) {
		$Secrets.('{0}ParseDateTimes' -f $secretPrefix) = $Script:ParseDateTimes.ToString()
	}
	foreach ($Secret in $Secrets.GetEnumerator()) {
		Write-Verbose ('Processing secret {0} for vault storage.' -f $Secret.Key)
		Write-Debug ('Secret {0} has type {1}.' -f $Secret.Key, $Secret.Value.GetType().Name)
		Write-Debug ('Secret {0} has value {1}.' -f $Secret.Key, $Secret.Value.ToString())
		$SecretName = $Secret.Key
		$SecretValue = $Secret.Value
		if ([String]::IsNullOrEmpty($SecretValue) -or ($null -eq $SecretValue)) {
			Write-Verbose ('Secret {0} is null. Skipping.' -f $SecretName)
			continue
		}
		Set-Secret -Vault $vaultName -Name $SecretName -Secret $SecretValue -ErrorAction Stop
		Write-Verbose ('Secret {0} written to secret vault {1}.' -f $SecretName, $vaultName)
	}
}
