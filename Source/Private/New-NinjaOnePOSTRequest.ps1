function New-NinjaOnePOSTRequest {
	<#
		.SYNOPSIS
			Builds a request for the NinjaOne API.
		.DESCRIPTION
			Wrapper function to build web requests for the NinjaOne API.
		.EXAMPLE
			Make a POST request to the organisations endpoint.

			PS C:\> New-NinjaOnePOSTRequest -Method "POST" -Resource "/v2/organizations"
		.OUTPUTS
			Outputs an object containing the response from the web request.
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSMissingParameterInlineComment', '', Justification = 'Internal private function does not require parameter descriptions.')]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Private function - no need to support.')]
	param (
		# The resource to send the request to.
		[Parameter(Mandatory = $True)]
		[String]$Resource,
		# A hashtable used to build the query string.
		[Hashtable]$QSCollection,
		# A hashtable used to build the body of the request.
		[Object]$Body,
		# Parse date/time values returned in JSON.
		[Switch]$ParseDateTime,
		# Enable multipart form-data detection for file uploads.
		[Switch]$UseMultipart
	)
	function Test-NinjaOneMultipartBody {
		<#
			.SYNOPSIS
				Detect multipart-compatible values.
			.DESCRIPTION
				Recursively inspects a value to determine whether it contains file paths,
				FileInfo objects, or HttpContent suitable for multipart form-data.
			.PARAMETER Value
				The value to inspect for multipart indicators.
			.OUTPUTS
				System.Boolean
		#>
		param([Object]$Value)
		if ($null -eq $Value) { return $false }
		if ($Value -is [System.Net.Http.HttpContent]) { return $true }
		if ($Value -is [System.IO.FileInfo]) { return $true }
		if ($Value -is [string]) { return (Test-Path -Path $Value) }
		if ($Value -is [array]) {
			foreach ($item in $Value) {
				if (Test-NinjaOneMultipartBody -Value $item) { return $true }
			}
		}
		if (($Value -is [hashtable]) -or ($Value -is [System.Collections.Specialized.OrderedDictionary]) -or ($Value -is [pscustomobject])) {
			foreach ($prop in ($Value.PSObject.Properties | Select-Object -ExpandProperty Value)) {
				if (Test-NinjaOneMultipartBody -Value $prop) { return $true }
			}
		}
		return $false
	}

	function ConvertTo-NinjaOneMultipartContent {
		<#
			.SYNOPSIS
				Build multipart form-data content from an object.
			.DESCRIPTION
				Converts hashtable or PSCustomObject values into MultipartFormDataContent,
				including file parts for file paths and FileInfo objects.
			.PARAMETER Value
				The object containing form-data parts.
			.OUTPUTS
				System.Net.Http.MultipartFormDataContent
		#>
		param([Object]$Value)
		$multipart = [System.Net.Http.MultipartFormDataContent]::new()

		function Add-FilePart {
			<#
				.SYNOPSIS
					Add a file part to multipart content.
				.DESCRIPTION
					Creates a StreamContent from a file path and appends it to the multipart payload.
				.PARAMETER Name
					The form field name to use for the part.
				.PARAMETER Path
					The file path to attach.
			#>
			param([string]$Name, [string]$Path)
			$fileStream = [System.IO.FileStream]::new($Path, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
			$fileContent = [System.Net.Http.StreamContent]::new($fileStream)
			$fileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse('application/octet-stream')
			$multipart.Add($fileContent, $Name, [System.IO.Path]::GetFileName($Path))
		}

		function Add-ValuePart {
			<#
				.SYNOPSIS
					Add a value part to multipart content.
				.DESCRIPTION
					Adds plain text or JSON string content to the multipart payload.
				.PARAMETER Name
					The form field name to use for the part.
				.PARAMETER PartValue
					The value to add to the multipart payload.
			#>
			param([string]$Name, [Object]$PartValue)
			if ($null -eq $PartValue) {
				return
			}
			if (($PartValue -is [hashtable]) -or ($PartValue -is [System.Collections.Specialized.OrderedDictionary]) -or ($PartValue -is [pscustomobject])) {
				$json = $PartValue | ConvertTo-Json -Depth 100
				$stringContent = [System.Net.Http.StringContent]::new($json, [System.Text.Encoding]::UTF8, 'application/json')
				$multipart.Add($stringContent, $Name)
				return
			}
			$stringContent = [System.Net.Http.StringContent]::new([string]$PartValue, [System.Text.Encoding]::UTF8, 'text/plain')
			$multipart.Add($stringContent, $Name)
		}

		if (($Value -is [hashtable]) -or ($Value -is [System.Collections.Specialized.OrderedDictionary]) -or ($Value -is [pscustomobject])) {
			foreach ($prop in $Value.PSObject.Properties) {
				$propName = $prop.Name
				$propValue = $prop.Value
				if ($propValue -is [array]) {
					foreach ($item in $propValue) {
						if ($item -is [System.IO.FileInfo]) {
							Add-FilePart -Name $propName -Path $item.FullName
						} elseif (($item -is [string]) -and (Test-Path -Path $item)) {
							Add-FilePart -Name $propName -Path $item
						} else {
							Add-ValuePart -Name $propName -PartValue $item
						}
					}
					continue
				}
				if ($propValue -is [System.IO.FileInfo]) {
					Add-FilePart -Name $propName -Path $propValue.FullName
					continue
				}
				if (($propValue -is [string]) -and (Test-Path -Path $propValue)) {
					Add-FilePart -Name $propName -Path $propValue
					continue
				}
				Add-ValuePart -Name $propName -PartValue $propValue
			}
			return $multipart
		}

		throw 'Multipart body must be a hashtable or PSCustomObject with file paths or FileInfo values.'
	}

	function Invoke-NinjaOneHttpContentRequest {
		<#
			.SYNOPSIS
				Send an HttpContent request using HttpClient.
			.DESCRIPTION
				Executes a request with the provided HttpContent and returns the parsed
				JSON response or status code.
			.PARAMETER Method
				HTTP method to use for the request.
			.PARAMETER Uri
				Request URI.
			.PARAMETER Content
				HttpContent payload to send.
			.PARAMETER ParseDateTime
				Parse date/time values from JSON responses.
			.OUTPUTS
				System.Object
		#>
		param(
			[String]$Method,
			[String]$Uri,
			[System.Net.Http.HttpContent]$Content,
			[Switch]$ParseDateTime
		)
		$client = [System.Net.Http.HttpClient]::new()
		try {
			$authValue = [System.Net.Http.Headers.AuthenticationHeaderValue]::new(
				$Script:NRAPIAuthenticationInformation.Type,
				$Script:NRAPIAuthenticationInformation.Access
			)
			$client.DefaultRequestHeaders.Authorization = $authValue
			
			$request = [System.Net.Http.HttpRequestMessage]::new([System.Net.Http.HttpMethod]::new($Method), $Uri)
			$request.Content = $Content
			$response = $client.SendAsync($request).GetAwaiter().GetResult()
			$rawContent = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
			if (-not $response.IsSuccessStatusCode) {
				throw "Request failed with status code $($response.StatusCode): $rawContent"
			}
			if ([string]::IsNullOrWhiteSpace($rawContent)) {
				return $response.StatusCode
			}
			$results = $rawContent | ConvertFrom-Json
			if ($ParseDateTime -and $null -ne $results) {
				$results = ConvertFrom-NinjaOneDateTime -InputObject $results
			}
			return $results
		} finally {
			if ($Content) { $Content.Dispose() }
			if ($client) { $client.Dispose() }
		}
	}
	if ($null -eq $Script:NRAPIConnectionInformation) {
		throw "Missing NinjaOne connection information, please run 'Connect-NinjaOne' first."
	}
	if ($null -eq $Script:NRAPIAuthenticationInformation) {
		throw "Missing NinjaOne authentication tokens, please run 'Connect-NinjaOne' first."
	}
	Test-NinjaOneEndpointSupport -Method 'POST' -Resource $Resource -Verbose:$VerbosePreference
	try {
		if ($QSCollection) {
			Write-Verbose "Query string in New-NinjaOnePOSTRequest contains: $($QSCollection | Out-String)"
			$QueryStringCollection = [System.Web.HTTPUtility]::ParseQueryString([String]::Empty)
			Write-Verbose 'Building [HttpQSCollection] for New-NinjaOnePOSTRequest'
			foreach ($Key in $QSCollection.Keys) {
				$QueryStringCollection.Add($Key, $QSCollection.$Key)
			}
		} else {
			Write-Verbose 'Query string collection not present...'
		}
		Write-Verbose "URI is $($Script:NRAPIConnectionInformation.URL)"
		$RequestUri = [System.UriBuilder]"$($Script:NRAPIConnectionInformation.URL)"
		Write-Verbose "Path is $($Resource)"
		$RequestUri.Path = $Resource
		if ($QueryStringCollection) {
			Write-Verbose "Query string is $($QueryStringCollection.toString())"
			$RequestUri.Query = $QueryStringCollection.toString()
		} else {
			Write-Verbose 'Query string not present...'
		}
		$WebRequestParams = @{
			Method = 'POST'
			Uri = $RequestUri.ToString()
		}
		if ($ParseDateTime -or $Script:ParseDateTimes) {
			$WebRequestParams.ParseDateTime = $true
		}
		if ($Body) {
			Write-Verbose 'Building [HttpBody] for New-NinjaOnePOSTRequest'
			$useParseDateTime = $ParseDateTime -or $Script:ParseDateTimes
			if ($UseMultipart -and ($Body -is [System.Net.Http.HttpContent] -or (Test-NinjaOneMultipartBody -Value $Body))) {
				Write-Verbose 'Detected multipart body, using HttpClient request method'
				# Avoid PowerShell collection unwrapping - MultipartFormDataContent is IEnumerable
				# Must use direct assignment in if/else, not if expression that returns values
				if ($Body -is [System.Net.Http.HttpContent]) {
					$multipartContent = $Body
					$null = $multipartContent
				} else {
					$multipartContent = ConvertTo-NinjaOneMultipartContent -Value $Body
				}
				$Result = Invoke-NinjaOneHttpContentRequest -Method 'POST' -Uri $RequestUri.ToString() -Content $multipartContent -ParseDateTime:$useParseDateTime
				Write-Verbose "NinjaOne request returned $($Result | Out-String)"
				if ($Result['results']) {
					return $Result.results
				} elseif ($Result['result']) {
					return $Result.result
				} else {
					return $Result
				}
			}
			$WebRequestParams.Body = (ConvertTo-Json -InputObject $Body -Depth 100)
			Write-Verbose "Raw body is $($WebRequestParams.Body)"
		} else {
			Write-Verbose 'No body provided for New-NinjaOnePOSTRequest'
		}
		Write-Verbose "Building new NinjaOneRequest with params: $($WebRequestParams | Out-String)"
		try {
			$Result = Invoke-NinjaOneRequest @WebRequestParams
			Write-Verbose "NinjaOne request returned $($Result | Out-String)"
			if ($Result['results']) {
				return $Result.results
			} elseif ($Result['result']) {
				return $Result.result
			} else {
				return $Result
			}
		} catch {
			$ExceptionType = if ($IsCoreCLR) {
				[Microsoft.PowerShell.Commands.HttpResponseException]
			} else {
				[System.Net.WebException]
			}
			if ($_.Exception -is $ExceptionType) {
				throw
			} else {
				New-NinjaOneError -ErrorRecord $_
			}
		}
	} catch {
		$ExceptionType = if ($IsCoreCLR) {
			[Microsoft.PowerShell.Commands.HttpResponseException]
		} else {
			[System.Net.WebException]
		}
		if ($_.Exception -is $ExceptionType) {
			throw
		} else {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
