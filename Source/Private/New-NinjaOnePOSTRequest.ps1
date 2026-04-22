function New-NinjaOnePOSTRequest {
	<#
		.SYNOPSIS
			Builds a request for the NinjaOne API.
		.DESCRIPTION
			Wrapper function to build web requests for the NinjaOne API.
		.EXAMPLE
			Make a POST request to the organisations endpoint.

			PS C:\> New-NinjaOnePOSTRequest -method "POST" -resource "/v2/organizations"
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
		[String]$resource,
		# A hashtable used to build the query string.
		[Hashtable]$qSCollection,
		# A hashtable used to build the body of the request.
		[Object]$body,
		# Parse date/time values returned in JSON.
		[Switch]$parseDateTime,
		# Enable multipart form-data detection for file uploads.
		[Switch]$useMultipart
	)
	function Get-NinjaOneMultipartEntries {
		<#
			.SYNOPSIS
				Enumerate multipart body entries.
			.DESCRIPTION
				Normalises hashtables, ordered dictionaries, and PSCustomObjects into
				name/value entries suitable for multipart processing.
			.PARAMETER Value
				The value to enumerate.
			.OUTPUTS
				System.Object[]
		#>
		param([Object]$value)
		if ($value -is [System.Collections.IDictionary]) {
			foreach ($entry in $value.GetEnumerator()) {
				[pscustomobject]@{
					Name = [string]$entry.Key
					Value = $entry.Value
				}
			}
			return
		}
		if ($value -is [pscustomobject]) {
			foreach ($property in $value.PSObject.Properties) {
				[pscustomobject]@{
					Name = $property.Name
					Value = $property.Value
				}
			}
		}
	}
	function Test-NinjaOneMultipartBody {
		<#
			.SYNOPSIS
				Detect multipart-compatible values.
			.DESCRIPTION
				Recursively inspects a value to determine whether it can be represented as
				multipart form-data, including object containers, file paths, FileInfo
				objects, and HttpContent values.
			.PARAMETER Value
				The value to inspect for multipart indicators.
			.OUTPUTS
				System.Boolean
		#>
		param([Object]$value)
		if ($null -eq $value) { return $false }
		if ($value -is [System.Net.Http.HttpContent]) { return $true }
		if ($value -is [System.IO.FileInfo]) { return $true }
		if ($value -is [string]) { return (Test-Path -Path $value) }
		if ($value -is [array]) {
			foreach ($item in $value) {
				if (Test-NinjaOneMultipartBody -Value $item) { return $true }
			}
		}
		if (($value -is [System.Collections.IDictionary]) -or ($value -is [pscustomobject])) {
			foreach ($entry in (Get-NinjaOneMultipartEntries -Value $value)) {
				if (Test-NinjaOneMultipartBody -Value $entry.Value) { return $true }
			}
			return $true
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
		param([Object]$value)
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
			param([string]$name, [string]$path)
			$fileStream = [System.IO.FileStream]::new($path, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
			$fileContent = [System.Net.Http.StreamContent]::new($fileStream)
			$fileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse('application/octet-stream')
			$multipart.Add($fileContent, $name, [System.IO.Path]::GetFileName($path))
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
			param([string]$name, [Object]$partValue)
			if ($null -eq $partValue) {
				return
			}
			if (($partValue -is [hashtable]) -or ($partValue -is [System.Collections.Specialized.OrderedDictionary]) -or ($partValue -is [pscustomobject])) {
				$json = $partValue | ConvertTo-Json -Depth 100
				$stringContent = [System.Net.Http.StringContent]::new($json, [System.Text.Encoding]::UTF8, 'text/plain')
				$multipart.Add($stringContent, $name)
				return
			}
			$stringContent = [System.Net.Http.StringContent]::new([string]$partValue, [System.Text.Encoding]::UTF8, 'text/plain')
			$multipart.Add($stringContent, $name)
		}

		if (($value -is [System.Collections.IDictionary]) -or ($value -is [pscustomobject])) {
			foreach ($prop in (Get-NinjaOneMultipartEntries -Value $value)) {
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
			return , $multipart
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
			[String]$method,
			[String]$uri,
			[Object]$content,
			[Switch]$parseDateTime
		)
		if ($content -isnot [System.Net.Http.HttpContent]) {
			throw ('Http content payload must be of type System.Net.Http.HttpContent. Received: {0}' -f $content.GetType().FullName)
		}
		$HttpContent = [System.Net.Http.HttpContent]$content
		$client = [System.Net.Http.HttpClient]::new()
		try {
			$authValue = [System.Net.Http.Headers.AuthenticationHeaderValue]::new(
				$Script:NRAPIAuthenticationInformation.Type,
				$Script:NRAPIAuthenticationInformation.Access
			)
			$client.DefaultRequestHeaders.Authorization = $authValue
			
			$request = [System.Net.Http.HttpRequestMessage]::new([System.Net.Http.HttpMethod]::new($method), $uri)
			$request.Content = $HttpContent
			Write-Verbose ('HttpContent request Content-Type: {0}' -f $request.Content.Headers.ContentType)
			$response = $client.SendAsync($request).GetAwaiter().GetResult()
			$rawContent = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
			if (-not $response.IsSuccessStatusCode) {
				throw ('Request failed with status code {0}: {1}' -f $response.StatusCode, $rawContent)
			}
			if ([string]::IsNullOrWhiteSpace($rawContent)) {
				return $response.StatusCode
			}
			$results = $rawContent | ConvertFrom-Json
			if ($parseDateTime -and $null -ne $results) {
				$results = ConvertFrom-NinjaOneDateTime -InputObject $results
			}
			return $results
		} finally {
			if ($HttpContent) { $HttpContent.Dispose() }
			if ($client) { $client.Dispose() }
		}
	}
	if ($null -eq $Script:NRAPIConnectionInformation) {
		throw "Missing NinjaOne connection information, please run 'Connect-NinjaOne' first."
	}
	if ($null -eq $Script:NRAPIAuthenticationInformation) {
		throw "Missing NinjaOne authentication tokens, please run 'Connect-NinjaOne' first."
	}
	Test-NinjaOneEndpointSupport -method 'POST' -resource $resource -Verbose:$VerbosePreference
	try {
		if ($qSCollection) {
			Write-Verbose ('Query string in New-NinjaOnePOSTRequest contains: {0}' -f ($qSCollection | Out-String))
			$QueryStringCollection = [System.Web.HTTPUtility]::ParseQueryString([String]::Empty)
			Write-Verbose 'Building [HttpQSCollection] for New-NinjaOnePOSTRequest'
			foreach ($Key in $qSCollection.Keys) {
				$QueryStringCollection.Add($Key, $qSCollection.$Key)
			}
		} else {
			Write-Verbose 'Query string collection not present...'
		}
		Write-Verbose ('URI is {0}' -f $Script:NRAPIConnectionInformation.URL)
		$RequestUri = [System.UriBuilder]$Script:NRAPIConnectionInformation.URL
		Write-Verbose ('Path is {0}' -f $resource)
		$RequestUri.Path = $resource
		if ($QueryStringCollection) {
			Write-Verbose ('Query string is {0}' -f $QueryStringCollection.toString())
			$RequestUri.Query = $QueryStringCollection.toString()
		} else {
			Write-Verbose 'Query string not present...'
		}
		$WebRequestParams = @{
			Method = 'POST'
			Uri = $RequestUri.ToString()
		}
		if ($parseDateTime -or $Script:ParseDateTimes) {
			$WebRequestParams.ParseDateTime = $true
		}
		if ($body) {
			Write-Verbose 'Building [HttpBody] for New-NinjaOnePOSTRequest'
			$useParseDateTime = $parseDateTime -or $Script:ParseDateTimes
			if ($useMultipart -and ($body -is [System.Net.Http.HttpContent] -or (Test-NinjaOneMultipartBody -Value $body))) {
				Write-Verbose 'Detected multipart body, using HttpClient request method'
				# Avoid PowerShell collection unwrapping - MultipartFormDataContent is IEnumerable
				# Must use direct assignment in if/else, not if expression that returns values
				if ($body -is [System.Net.Http.HttpContent]) {
					$multipartContent = $body
					$null = $multipartContent
				} else {
					$multipartContent = ConvertTo-NinjaOneMultipartContent -Value $body
					Write-Verbose ('Multipart request body: {0}' -f ($body | ConvertTo-Json -Depth 100))
				}
				Write-Verbose ('Multipart payload runtime type: {0}' -f $multipartContent.GetType().FullName)
				$Result = Invoke-NinjaOneHttpContentRequest -method 'POST' -uri $RequestUri.ToString() -content ([System.Net.Http.HttpContent]$multipartContent) -parseDateTime:$useParseDateTime
				Write-Verbose ('NinjaOne request returned {0}' -f ($Result | Out-String))
				if ($Result['results']) {
					return $Result.results
				} elseif ($Result['result']) {
					return $Result.result
				} else {
					return $Result
				}
			}
			$WebRequestParams.Body = (ConvertTo-Json -InputObject $body -Depth 100)
			Write-Verbose ('Raw body is {0}' -f $WebRequestParams.Body)
		} else {
			Write-Verbose 'No body provided for New-NinjaOnePOSTRequest'
		}
		Write-Verbose ('Building new NinjaOneRequest with params: {0}' -f ($WebRequestParams | Out-String))
		try {
			$Result = Invoke-NinjaOneRequest @WebRequestParams
			Write-Verbose ('NinjaOne request returned {0}' -f ($Result | Out-String))
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
