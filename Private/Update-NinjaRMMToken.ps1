function Update-NinjaRMMToken {
    [CmdletBinding()]
    [OutputType([Void])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Private function - no need to support.')]
    param()
    try {
        # Using our refresh token let's get a new auth token by re-running Connect-NinjaRMM.
        $ReauthParams = @{
            Instance = $Script:NRAPIConnectionInformation.Instance
            ClientID = $Script:NRAPIConnectionInformation.ClientID
            ClientSecret = $Script:NRAPIConnectionInformation.ClientSecret
            RefreshToken = $Script:NRAPIAuthenticationInformation.Refresh
            UseTokenAuth = $True
            ShowTokens = $False
        }
        Connect-NinjaRMM @ReauthParams
        Write-Verbose 'Refreshed authentication token information from NinjaRMM.'
        Write-Debug "Authentication information now set to: $($Script:NRAPIAuthenticationInformation | Out-String -Width 2048)"
    } catch {
        Throw
    }
}