function New-NinjaOneGETRequest {
	<#
		.SYNOPSIS
			Builds a request for the NinjaOne API.
		.DESCRIPTION
			Wrapper function to build web requests for the NinjaOne API.
		.EXAMPLE
			Make a GET request to the organisations endpoint.

			PS C:\> New-NinjaOneGETRequest -resource "/v2/organizations"
		.OUTPUTS
			Outputs an object containing the response from the web request.
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Private function - no need to support.')]
	param (
		# The resource to send the request to.
		[Parameter( Mandatory = $True )]
		[String]$resource,
		# A hashtable used to build the query string.
		[HashTable]$qSCollection,
		# return the raw response.
		[Switch]$raw,
		# Parse date/time values returned in JSON.
		[Switch]$parseDateTime
	)
	if ($null -eq $Script:NRAPIConnectionInformation) {
		throw "Missing NinjaOne connection information, please run 'Connect-NinjaOne' first."
	}
	if ($null -eq $Script:NRAPIAuthenticationInformation) {
		throw "Missing NinjaOne authentication tokens, please run 'Connect-NinjaOne' first."
	}
	Test-NinjaOneEndpointSupport -Method 'GET' -resource $resource -Verbose:$VerbosePreference
	try {
		if ($qSCollection) {
			Write-Verbose "Query string in New-NinjaOneGETRequest contains: $($qSCollection | Out-String)"
			$QueryStringCollection = [System.Web.HTTPUtility]::ParseQueryString([String]::Empty)
			Write-Verbose 'Building [HttpQSCollection] for New-NinjaOneGETRequest'
			foreach ($Key in $qSCollection.Keys) {
				$QueryStringCollection.Add($Key, $qSCollection.$Key)
			}
		} else {
			Write-Verbose 'Query string collection not present...'
		}
		Write-Verbose "URI is $($Script:NRAPIConnectionInformation.URL)"
		$RequestUri = [System.UriBuilder]"$($Script:NRAPIConnectionInformation.URL)"
		$RequestUri.Path = $resource
		if ($QueryStringCollection) {
			$RequestUri.Query = $QueryStringCollection.toString()
		} else {
			Write-Verbose 'No query string collection present.'
		}
		$WebRequestParams = @{
			Method = 'GET'
			Uri = $RequestUri.ToString()
		}
		if ($raw) {
			$WebRequestParams.Add('Raw', $raw)
		} elseif ($parseDateTime -or $Script:ParseDateTimes) {
			$WebRequestParams.Add('ParseDateTime', $true)
		} else {
			Write-Verbose 'Raw switch not present.'
		}
		if ($WebRequestParams) {
			Write-Verbose "WebRequestParams contains: $($WebRequestParams | Out-String)"
		} else {
			Write-Verbose 'WebRequestParams is empty.'
		}
		try {
			$Result = Invoke-NinjaOneRequest @WebRequestParams
			if ($Result) {
				Write-Verbose "NinjaOne request returned:: $($Result | Out-String)"
				$Properties = ($Result | Get-Member -MemberType 'NoteProperty')
				if ($Properties.name -contains 'results') {
					Write-Verbose "returning 'results' property.'"
					Write-Verbose "Result type is $($Result.results.GetType())"
					return $Result.results
				} elseif ($Properties.name -contains 'result') {
					Write-Verbose "returning 'result' property."
					Write-Verbose "Result type is $($Result.result.GetType())"
					return $Result.result
				} else {
					Write-Verbose 'returning raw.'
					Write-Verbose "Result type is $($Result.GetType())"
					return $Result
				}
			} else {
				Write-Verbose 'NinjaOne request returned nothing.'
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
