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
			ShowTokens = $Script:NRAPIConnectionInformation.ShowTokens
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
		Write-Verbose ('Authentication information now set to: {0}' -f ($Script:NRAPIAuthenticationInformation | Out-String -Width 2048))
	} catch {
		New-NinjaOneError $_
	}
}
