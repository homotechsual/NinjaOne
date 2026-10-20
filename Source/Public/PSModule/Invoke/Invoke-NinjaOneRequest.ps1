
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
			PS> Invoke-NinjaOneRequest -method 'GET' -uri 'https://eu.ninjarmm.com/v2/activities'

			Make a GET request to the activities resource.
		.EXAMPLE
			PS> Invoke-NinjaOneRequest -method 'GET' -uri 'https://eu.ninjarmm.com/v2/activities' -parseDateTime

			Parse ISO 8601 and Unix epoch values in the response to [DateTime].
		.EXAMPLE
			PS> Invoke-NinjaOneRequest -method 'GET' -uri 'https://eu.ninjarmm.com/v2/activities' -parseDateTime

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
		[String]$method,
		# The URI to send the request to.
		[Parameter(Mandatory, Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[String]$uri,
		# The body of the request.
		[Parameter(Position = 2)]
		[String]$body,
		# Return the raw response - don't convert from JSON.
		[Switch]$raw,
		# Parse date/time values returned in JSON.
		[Switch]$parseDateTime

	)
	begin {
		Invoke-NinjaOnePreFlightCheck
		$Now = Get-Date
		$TokenExpiry = $Script:NRAPIAuthenticationInformation.Expires
		if (($TokenExpiry -is [DateTime]) -and ($TokenExpiry -le $Now)) {
			Write-Verbose 'The auth token has expired, renewing.'
			Update-NinjaOneToken -Verbose:$VerbosePreference
		}
		if ($null -ne $Script:NRAPIAuthenticationInformation) {
			$AuthHeaders = @{
				Authorization = ('{0} {1}' -f $Script:NRAPIAuthenticationInformation.Type, $Script:NRAPIAuthenticationInformation.Access)
			}
		} else {
			$AuthHeaders = $null
		}
	}
	process {
		try {
			$WebRequestParams = @{
				Method = $method
				Uri = $uri
			}
			if ($body) {
				Write-Verbose 'Request body values omitted.'
				$WebRequestParams.Add('Body', $body)
			} else {
				Write-Verbose 'No body present.'
			}
			if ($PSVersionTable.PSVersion.Major -eq 5) {
				$WebRequestParams.UseBasicParsing = $true
			}
			Write-Verbose ('Making a {0} request.' -f $WebRequestParams.Method)
			$Attempt = 0
			$Response = $null
			do {
				$Attempt++
				$Response = Invoke-WebRequest @WebRequestParams -Headers $AuthHeaders -ContentType 'application/json;charset=utf-8'
				# NinjaOne signals rate limiting by returning an HTML page (not a 429). Only retry safe GET requests; mutating requests should surface the HTML response instead of retrying.
				$ContentType = [String]$Response.Headers['Content-Type']
				$TrimmedContent = ([String]$Response.Content).TrimStart()
				$IsHtmlResponse = ($ContentType -match 'text/html') -or ($TrimmedContent -match '^(?i)<(!DOCTYPE|html)')
				$HasRateLimitSignature = $TrimmedContent -match '(?i)(rate\s*limit|too\s*many\s*requests|request\s*limit\s*exceeded)'
				$IsRateLimitedResponse = (-not $raw) -and ($method -ieq 'GET') -and $IsHtmlResponse -and $HasRateLimitSignature
				if ($IsRateLimitedResponse) {
					if ($Attempt -gt $Script:NRAPIRateLimitMaxRetries) {
						throw ('NinjaOne API rate limit exceeded - received an HTML response after {0} attempts.' -f $Attempt)
					}
					$DelaySeconds = $Script:NRAPIRateLimitInitialDelaySeconds * [Math]::Pow(2, $Attempt - 1)
					Write-Verbose ('Received an HTML response, likely rate limited. Retrying attempt {0}/{1} after {2}s.' -f $Attempt, $Script:NRAPIRateLimitMaxRetries, $DelaySeconds)
					Start-Sleep -Seconds $DelaySeconds
				}
			} while ($IsRateLimitedResponse)
			if ($IsHtmlResponse -and -not $raw) {
				$ResponsePreview = if ($TrimmedContent.Length -gt 500) { $TrimmedContent.Substring(0, 500) } else { $TrimmedContent }
				throw ('NinjaOne API returned an HTML response for the {0} request: {1}' -f $method, $ResponsePreview)
			}
			Write-Verbose ('Response status code: {0}' -f $Response.StatusCode)
			if ($Response.Content) {
				Write-Verbose 'Response content received; values omitted.'
			} else {
				Write-Verbose 'No response content.'
			}
			if ($raw) {
				Write-Verbose 'Raw switch present, returning raw response.'
				$Results = $Response.Content
			} else {
				Write-Verbose 'Raw switch not present, converting response from JSON.'
				if ([string]::IsNullOrWhiteSpace([string]$Response.Content)) {
					$Results = $null
				} else {
					$Results = $Response.Content | ConvertFrom-Json
					if ($parseDateTime -and $null -ne $Results) {
						$Results = ConvertFrom-NinjaOneDateTime -InputObject $Results
					}
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
