<#
.SYNOPSIS
Update Token.

.DESCRIPTION
Internal helper function for Update-NinjaOneToken operations.

This function provides supporting functionality for the NinjaOne module.

.PARAMETER Parameter1
    Describes the first parameter.

.PARAMETER Parameter2
    Describes the second parameter.

.EXAMPLE
    PS> Update-NinjaOneToken

    update the specified Token.

.OUTPUTS
Returns information about the Token resource.

.NOTES
This cmdlet is part of the NinjaOne PowerShell module.
Generated reference help - customize descriptions as needed.
#>
function Update-NinjaOneToken {
	[CmdletBinding()]
	[OutputType([Void])]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Private function - no need to support.')]
	param()
	try {
		# Using our refresh token let's get a new auth token by re-running Connect-NinjaOne.
		$ReauthParams = @{
			Instance = $Script:NRAPIConnectionInformation.Instance
			ClientId = $Script:NRAPIConnectionInformation.ClientId
			ClientSecret = $Script:NRAPIConnectionInformation.ClientSecret
		}
		if ($Script:NRAPIConnectionInformation.AuthScopes) {
			$ReauthParams.Scopes = @($Script:NRAPIConnectionInformation.AuthScopes -split '\s+')
		}
		if ($Script:NRAPIConnectionInformation.UseSecretManagement -and -not [String]::IsNullOrWhiteSpace($Script:NRAPIConnectionInformation.VaultName)) {

			$ReauthParams.UseSecretManagement = $true
			$ReauthParams.VaultName = $Script:NRAPIConnectionInformation.VaultName
			if ($Script:NRAPIConnectionInformation.WriteToSecretVault) {

				$ReauthParams.WriteToSecretVault = $true

				if ($Script:NRAPIConnectionInformation.SecretPrefix) {
					$ReauthParams.SecretPrefix = $Script:NRAPIConnectionInformation.SecretPrefix
				}
				if ($Script:NRAPIConnectionInformation.RedirectURI) {
					$ReauthParams.RedirectURL = $Script:NRAPIConnectionInformation.RedirectURI.ToString()
				}
				if ($Script:NRAPIConnectionInformation.AuthListenerPort) {
					$ReauthParams.Port = $Script:NRAPIConnectionInformation.AuthListenerPort
		if ($Script:ParseDateTimes) {
			}
		}
		if ($Script:NRAPIConnectionInformation.ParseDateTimes) {
			$ReauthParams.ParseDateTimes = $true
		}
		if ($Script:NRAPIConnectionInformation.AuthMode -eq 'Client Credentials') {
			$ReauthParams.UseClientAuth = $True
		} elseif ($null -ne $Script:NRAPIAuthenticationInformation.Refresh) {
			$ReauthParams.RefreshToken = $Script:NRAPIAuthenticationInformation.Refresh
			$ReauthParams.UseTokenAuth = $True
		} else {
			throw 'Unable to refresh authentication token information. Not using client credentials and/or refresh token is missing.'
		}
		if ($Script:NRAPIConnectionInformation.UseSecretManagement) {
			if ([String]::IsNullOrWhiteSpace($Script:NRAPIConnectionInformation.VaultName)) {
				Write-Verbose 'Secret management is enabled, but no secret vault name is configured. Refreshing without secret vault updates.'
			}
		}
		Connect-NinjaOne @ReauthParams
		Write-Verbose 'Refreshed authentication token information from NinjaOne.'
		Write-Verbose ('Authentication information refreshed with properties: {0}' -f (@($Script:NRAPIAuthenticationInformation.Keys) -join ', '))
	} catch {
		New-NinjaOneError $_
	}
}
