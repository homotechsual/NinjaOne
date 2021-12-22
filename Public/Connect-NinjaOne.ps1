#Requires -Version 7
function Connect-NinjaOne {
    <#
        .SYNOPSIS
            Creates a new connection to a NinjaOne instance.
        .DESCRIPTION
            Creates a new connection to a NinjaOne instance and stores this in a PowerShell Session.
        .EXAMPLE
            PS C:\> Connect-NinjaOne -Instance "eu"
            This logs into NinjaOne using the Authorisation Code authorisation flow.
        .OUTPUTS
            Sets two script-scoped variables to hold connection and authentication information.
    #>
    [CmdletBinding( DefaultParameterSetName = 'Authorisation Code' )]
    [OutputType([System.Void])]
    Param (
        # Use the "Authorisation Code" flow with your web browser.
        [Parameter( ParameterSetName = 'Authorisation Code', Mandatory = $True )]
        [Switch]$UseWebAuth,
        # Use the "Token Authentication" flow - useful if you already have a refresh token.
        [Parameter( ParameterSetName = 'Token Authentication', Mandatory = $True )]
        [switch]$UseTokenAuth,
        # Use the "Client Credentials" flow - useful if you already have a client ID and secret.
        [Parameter( ParameterSetName = 'Client Credentials', Mandatory = $True )]
        [switch]$UseClientAuth,
        # The NinjaOne instance to connect to. Choose from 'eu', 'oc' or 'us'.
        [Parameter( ParameterSetName = 'Authorisation Code', Mandatory = $True )]
        [Parameter( ParameterSetName = 'Token Authentication', Mandatory = $True )]
        [Parameter( ParameterSetName = 'Client Credentials', Mandatory = $True )]
        [ValidateSet('eu', 'oc', 'us')]
        [string]$Instance,
        # The Client ID for the application configured in NinjaOne.
        [Parameter( ParameterSetName = 'Authorisation Code', Mandatory = $True )]
        [Parameter( ParameterSetName = 'Token Authentication', Mandatory = $True )]
        [Parameter( ParameterSetName = 'Client Credentials', Mandatory = $True )]
        [String]$ClientID,
        # The Client Secret for the application configured in NinjaOne.
        [Parameter( ParameterSetName = 'Authorisation Code', Mandatory = $True )]
        [Parameter( ParameterSetName = 'Token Authentication', Mandatory = $True )]
        [Parameter( ParameterSetName = 'Client Credentials', Mandatory = $True )]
        [String]$ClientSecret,
        # The API scopes to request, if this isn't passed the scope is assumed to be "all". Pass a string or array of strings. Limited by the scopes granted to the application in NinjaOne.
        [Parameter( ParameterSetName = 'Authorisation Code' )]
        [Parameter( ParameterSetName = 'Token Authentication' )]
        [Parameter( ParameterSetName = 'Client Credentials' )]
        [ValidateSet('monitoring', 'management', 'control', 'offline_access')]
        [String[]]$Scopes = @('monitoring', 'management', 'control', 'offline_access'),
        # The redirect URI to use. If not set defaults to 'http://localhost'. Should be a full URI e.g. https://redirect.example.uk:9090/auth
        [Parameter( ParameterSetName = 'Authorisation Code' )]
        [URI]$RedirectURL,
        # The port to use for the redirect URI. Must match with the configuration set in NinjaOne. If not set defaults to '9090'.
        [Parameter( ParameterSetName = 'Authorisation Code' )]
        [Int]$Port = 9090,
        # The refresh token to use for "Token Authentication" flow.
        [Parameter( ParameterSetName = 'Token Authentication' )]
        [String]$RefreshToken,
        # Output the tokens - useful when using "Authorisation Code" flow - to use with "Token Authentication" flow.
        [Parameter( ParameterSetName = 'Authorisation Code' )]
        [Parameter( ParameterSetName = 'Token Authentication' )]
        [Switch]$ShowTokens
    )
    $CommandName = $MyInvocation.InvocationName
    # Convert scopes to space separated string if it's an array.
    if ($Scopes -is [System.Array]) {
        $AuthScopes = $Scopes -Join ' '
    } else {
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
    # Build a script-scoped variable to hold the connection information.
    $ConnectionInformation = @{
        AuthMode = $PSCmdlet.ParameterSetName
        URL = $URL
        Instance = $Instance
        ClientID = $ClientID
        ClientSecret = $ClientSecret
        AuthListenerPort = $Port
        AuthScopes = $AuthScopes
        RedirectURI = $RedirectURI
    }
    Set-Variable -Name 'NRAPIConnectionInformation' -Value $ConnectionInformation -Visibility Private -Scope Script -Force
    Write-Debug "Connection information set to: $($Script:NRAPIConnectionInformation | Out-String)"
    $AuthenticationInformation = [HashTable]@{}
    # Set a script-scoped variable to hold authentication information.
    Set-Variable -Name 'NRAPIAuthenticationInformation' -Value $AuthenticationInformation -Visibility Private -Scope Script -Force
    if ($UseWebAuth) {
        # NinjaOne authorisation request query params.
        $AuthReqParams = @{
            response_type = 'code'
            client_id = $Script:NRAPIConnectionInformation.ClientID
            client_secret = $Script:NRAPIConnectionInformation.ClientSecret
            redirect_uri = $Script:NRAPIConnectionInformation.RedirectURI.ToString()
            state = $GUID
        }
        if ($Script:NRAPIConnectionInformation.AuthScopes) {
            $AuthReqParams.scope = $Script:NRAPIConnectionInformation.AuthScopes
        }
        # Build the authentication URI.
        # Start with the query string.
        $AuthReqQuery = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
        $AuthReqParams.GetEnumerator() | ForEach-Object {
            $AuthReqQuery.Add($_.Key, $_.Value)
        }
        # Now the authentication URI
        $AuthReqURI = [System.UriBuilder]$URL
        $AuthReqURI.Path = 'oauth/authorize'
        $AuthReqURI.Query = $AuthReqQuery.ToString()
        Write-Debug "Authentication request query string is $($AuthReqQuery.ToString())"
        try {
            # Get our authorisation code.
            Write-Verbose 'Opening browser to authenticate.'
            Write-Debug "Authentication URL: $($AuthReqURI.ToString())"
            Start-Process $AuthReqURI.ToString()
            $OAuthListenerDirectory = Join-Path "$((Get-Item $PSScriptRoot).Parent.FullName)" 'OAuthListener'
            $Script:NRAPIAuthenticationInformation.Code = dotnet run --project $OAuthListenerDirectory -- $Port
            if ($null -ne $Script:NRAPIAuthenticationInformation.Code) {
                $GotAuthorisationCode = $True
            }
        } catch {
            $ErrorRecord = @{
                ExceptionType = 'System.Net.Http.HttpRequestException'
                ErrorRecord = $_
                ErrorCategory = 'ProtocolError'
                BubbleUpDetails = $True
                CommandName = $CommandName
            }
            New-NinjaOneError @ErrorRecord
        }
    } 
    if (($UseTokenAuth) -or ($GotAuthorisationCode)) {
        Write-Verbose 'Getting authentication token.'
        try {
            $TokenRequestBody = @{
                grant_type = 'client_credentials'
                client_id = $Script:NRAPIConnectionInformation.ClientID
                client_secret = $Script:NRAPIConnectionInformation.ClientSecret
                code = $Script:NRAPIAuthenticationInformation.Code
                redirect_uri = $Script:NRAPIConnectionInformation.RedirectURI
            }
            # Using our authorisation code let's get an auth token.
            $TokenRequestUri = [System.UriBuilder]$URL
            $TokenRequestUri.Path = 'oauth/token' 
            $TokenRequestParams = @{
                Uri = $TokenRequestUri.ToString()
                Method = 'POST'
                Body = $TokenRequestBody
                ContentType = 'application/x-www-form-urlencoded'
            }
            $TokenResult = Invoke-WebRequest @TokenRequestParams
            $TokenPayload = $TokenResult.Content | ConvertFrom-Json
            # Update our script-scoped NRAPIAuthenticationInformation variable with the token.
            $Script:NRAPIAuthenticationInformation.Type = $TokenPayload.token_type
            $Script:NRAPIAuthenticationInformation.Access = $TokenPayload.access_token
            $Script:NRAPIAuthenticationInformation.Expires = Get-TokenExpiry -ExpiresIn $TokenPayload.expires_in
            $Script:NRAPIAuthenticationInformation.Refresh = $TokenPayload.refresh_token
            Write-Verbose 'Got authentication token information from NinjaOne.'
            Write-Debug "Authentication information set to: $($Script:NRAPIAuthenticationInformation | Out-String -Width 2048)"
            if ($ShowTokens) {
                Write-Output '================ Auth Tokens ================'
                Write-Output $($Script:NRAPIAuthenticationInformation | Format-Table)
                Write-Output '       SAVE THESE IN A SECURE LOCATION       '
            }
        } catch {
            $ErrorRecord = @{
                ExceptionType = 'System.Net.Http.HttpRequestException'
                ErrorRecord = $_
                ErrorCategory = 'ProtocolError'
                BubbleUpDetails = $True
                CommandName = $CommandName
            }
            New-NinjaOneError @ErrorRecord
        }
    }
    if ($UseClientAuth) {
        
    }
}