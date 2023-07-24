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
                ClientID = $Script:NRAPIConnectionInformation.ClientID
                ClientSecret = $Script:NRAPIConnectionInformation.ClientSecret
                UseClientAuth = $True
                ShowTokens = $False
            }
        } else {
            $ReauthParams = @{
                Instance = $Script:NRAPIConnectionInformation.Instance
                ClientID = $Script:NRAPIConnectionInformation.ClientID
                ClientSecret = $Script:NRAPIConnectionInformation.ClientSecret
                RefreshToken = $Script:NRAPIAuthenticationInformation.Refresh
                UseTokenAuth = $True
                ShowTokens = $False
            }
        }
        Connect-NinjaOne @ReauthParams
        Write-Verbose 'Refreshed authentication token information from NinjaOne.'
        Write-Debug "Authentication information now set to: $($Script:NRAPIAuthenticationInformation | Out-String -Width 2048)"
    } catch {
        New-NinjaOneError $_
    }
}