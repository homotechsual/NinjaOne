
function Start-OAuthHTTPListener {
	<#
		.SYNOPSIS
			Instantiates and starts a .NET HTTP listener to handle OAuth authorization code responses.
		.DESCRIPTION
			Utilises the `System.Net.HttpListener` class to create a simple HTTP listener on a user-defined port
		.EXAMPLE
			PS C:\> New-NinjaOnePATCHRequest -OpenURI 'http://localhost:9090'
		.OUTPUTS
			Outputs an object containing the response from the web request.
	#>
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Private function - no need to support.')]
	param (
		[Parameter(Mandatory)]
		[System.UriBuilder]$OpenURI,
		[Parameter()]
		[int] $TimeoutSeconds = 15
	)
	Write-Verbose 'Opening browser to authenticate.'
	Write-Verbose "Authentication URL: $($OpenURI.ToString())"
	$HTTP = [System.Net.HttpListener]::new()
	$HTTP.Prefixes.Add("http://localhost:$Port/")
	$HTTP.Start()
	Start-Process $OpenURI.ToString()
	$Timeout = [System.TimeSpan]::FromSeconds($TimeoutSeconds)
	$ContextTask = $HTTP.GetContextAsync()
	$Result = @{}
	while ($ContextTask.AsyncWaitHandle.WaitOne($Timeout)) {
		$Context = $ContextTask.GetAwaiter().GetResult()

		[string]$HTML = '<h1>NinjaOne PowerShell Module</h1><br /><p>An authorisation code has been received. The HTTP listener will stop in 5 seconds.</p><p>Please close this tab / window.</p>'
		[string]$HTMLError = '<h1>NinjaOne PowerShell Module</h1><br /><p>An error occured. The HTTP listener will stop in 5 seconds.</p><p>Please close this tab / window and try again.</p>'

		if ($Context.Request.QueryString -and $Context.Request.QueryString['Code']) {
			$Result.Code = $Context.Request.QueryString['Code']
			Write-Verbose "Authorisation code received: $($Result.Code)"
			if ($null -ne $Result.Code) {
				$Result.GotAuthorisationCode = $True
			}
		} else {
			$HTML = $HTMLError
		}

		$Response = [System.Text.Encoding]::UTF8.GetBytes($HTML)
		$Context.Response.ContentLength64 = $Response.Length
		$Context.Response.OutputStream.Write($Response, 0, $Response.Length)
		$Context.Response.OutputStream.Close()
		Start-Sleep -Seconds 5
		$HTTP.Stop()
		$HTTP.Dispose()
		break
	}

	if ($HTTP.IsListening) {
		$HTTP.Stop()
		$HTTP.Dispose()
	}

	if (!$Result.GotAuthorisationCode) {
		Remove-Variable -Name 'NRAPIConnectionInformation' -Scope 'Script' -Force
		Remove-Variable -Name 'NRAPIAuthenticationInformation' -Scope 'Script' -Force
		throw 'Authorisation failed, please try again.'
	}
	return $Result
}
