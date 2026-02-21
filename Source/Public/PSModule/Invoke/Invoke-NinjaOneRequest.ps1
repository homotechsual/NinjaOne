
function Invoke-NinjaOneRequest {
	<#
		.SYNOPSIS
			Sends a request to the NinjaOne API.
		.DESCRIPTION
			Wrapper function to send web requests to the NinjaOne API.
		.PARAMETER ParseDateTime
			Convert ISO 8601 or Unix epoch values in JSON responses to [DateTime].
		.FUNCTIONALITY
			API Request
		.EXAMPLE
			PS> Invoke-NinjaOneRequest -Method 'GET' -Uri 'https://eu.ninjarmm.com/v2/activities'

			Make a GET request to the activities resource.
		.EXAMPLE
			PS> Invoke-NinjaOneRequest -Method 'GET' -Uri 'https://eu.ninjarmm.com/v2/activities' -ParseDateTime

			Parse ISO 8601 and Unix epoch values in the response to [DateTime].
		.EXAMPLE
			PS> Invoke-NinjaOneRequest -Method 'GET' -Uri 'https://eu.ninjarmm.com/v2/activities' -ParseDateTime

			Make a GET request and convert ISO 8601 or Unix epoch values to [DateTime].
		.OUTPUTS
			Outputs an object containing the response from the web request.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/apirequest
	#>
	[Cmdletbinding()]
	[OutputType([Object])]
	[Alias('inor')]
	[MetadataAttribute('IGNORE')]
	param (
		# HTTP method to use.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[ValidateSet('GET', 'POST', 'PUT', 'PATCH', 'DELETE')]
		[String]$Method,
		# The URI to send the request to.
		[Parameter(Mandatory, Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[String]$Uri,
		# The body of the request.
		[Parameter(Position = 2)]
		[String]$Body,
		# Return the raw response - don't convert from JSON.
		[Switch]$Raw,
		# Parse date/time values returned in JSON.
		[Switch]$ParseDateTime

	)
	begin {
		if ($null -eq $Script:NRAPIConnectionInformation) {
			throw "Missing NinjaOne connection information, please run 'Connect-NinjaOne' first."
		}
		if ($null -eq $Script:NRAPIAuthenticationInformation) {
			throw "Missing NinjaOne authentication tokens, please run 'Connect-NinjaOne' first."
		}
		$Now = Get-Date
		if ($Script:NRAPIAuthenticationInformation.Expires -le $Now) {
			Write-Verbose 'The auth token has expired, renewing.'
			Update-NinjaOneToken -Verbose:$VerbosePreference
		}
		if ($null -ne $Script:NRAPIAuthenticationInformation) {
			$AuthHeaders = @{
				Authorization = "$($Script:NRAPIAuthenticationInformation.Type) $($Script:NRAPIAuthenticationInformation.Access)"
			}
		} else {
			$AuthHeaders = $null
		}
	}
	process {
		try {
			Write-Verbose ('Making a {0} request to {1}' -f $WebRequestParams.Method, $WebRequestParams.Uri)
			$WebRequestParams = @{
				Method = $Method
				Uri = $Uri
			}
			if ($Body) {
				Write-Verbose ('Body is {0}' -f ($Body | Out-String))
				$WebRequestParams.Add('Body', $Body)
			} else {
				Write-Verbose 'No body present.'
			}
			if ($PSVersionTable.PSVersion.Major -eq 5) {
				$WebRequestParams.UseBasicParsing = $true
			}
			$Response = Invoke-WebRequest @WebRequestParams -Headers $AuthHeaders -ContentType 'application/json;charset=utf-8'
			Write-Verbose ('Response status code: {0}' -f $Response.StatusCode)
			Write-Verbose ('Response headers: {0}' -f ($Response.Headers | Out-String))
			Write-Verbose ('Raw response: {0}' -f ($Response | Out-String))
			if ($Response.Content) {
				$ResponseContent = $Response.Content
			} else {
				$ResponseContent = 'No content'
			}
			if ($Response.Content) {
				Write-Verbose ('Response content: {0}' -f ($ResponseContent | Out-String))
			} else {
				Write-Verbose 'No response content.'
			}
			if ($Raw) {
				Write-Verbose 'Raw switch present, returning raw response.'
				$Results = $Response.Content
			} else {
				Write-Verbose 'Raw switch not present, converting response from JSON.'
				$Results = $Response.Content | ConvertFrom-Json
				if ($ParseDateTime) {
					$Results = ConvertFrom-NinjaOneDateTime -InputObject $Results
				}
			}
			if ($null -eq $Results) {
				if ($Response.StatusCode -and $WebRequestParams.Method -ne 'GET') {
					Write-Verbose ('Request completed with status code {0}. No content in the response - returning Status Code.' -f $Response.StatusCode)
					$Results = $Response.StatusCode
				} else {
					Write-Verbose 'Request completed with no results and/or no status code.'
					$Results = @{}
				}
			}
			return $Results
		} catch {
			throw $_
		}
	}
}
