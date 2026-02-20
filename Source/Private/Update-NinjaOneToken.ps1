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
		if ($Script:NRAPIConnectionInformation.AuthMode -eq 'Client Credentials') {
			$ReauthParams = @{
				Instance = $Script:NRAPIConnectionInformation.Instance
				ClientId = $Script:NRAPIConnectionInformation.ClientId
				ClientSecret = $Script:NRAPIConnectionInformation.ClientSecret
				UseClientAuth = $True
				ShowTokens = $Script:NRAPIConnectionInformation.ShowTokens
				UseKeyVault = $Script:NRAPIConnectionInformation.UseKeyVault
				VaultName = $Script:NRAPIConnectionInformation.VaultName
				WriteToKeyVault = $Script:NRAPIConnectionInformation.WriteToKeyVault
			}
		} elseif ($null -ne $Script:NRAPIAuthenticationInformation.Refresh) {
			$ReauthParams = @{
				Instance = $Script:NRAPIConnectionInformation.Instance
				ClientId = $Script:NRAPIConnectionInformation.ClientId
				ClientSecret = $Script:NRAPIConnectionInformation.ClientSecret
				RefreshToken = $Script:NRAPIAuthenticationInformation.Refresh
				UseTokenAuth = $True
				ShowTokens = $Script:NRAPIConnectionInformation.ShowTokens
				UseKeyVault = $Script:NRAPIConnectionInformation.UseKeyVault
				VaultName = $Script:NRAPIConnectionInformation.VaultName
				WriteToKeyVault = $Script:NRAPIConnectionInformation.WriteToKeyVault
			}
		} else {
			throw 'Unable to refresh authentication token information. Not using client credentials and/or refresh token is missing.'
		}
		Connect-NinjaOne @ReauthParams
		Write-Verbose 'Refreshed authentication token information from NinjaOne.'
		Write-Verbose "Authentication information now set to: $($Script:NRAPIAuthenticationInformation | Out-String -Width 2048)"
	} catch {
		New-NinjaOneError $_
	}
}
