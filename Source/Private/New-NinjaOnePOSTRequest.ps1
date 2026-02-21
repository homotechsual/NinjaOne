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
		[Switch]$ParseDateTime
	)
	if ($null -eq $Script:NRAPIConnectionInformation) {
		throw "Missing NinjaOne connection information, please run 'Connect-NinjaOne' first."
	}
	if ($null -eq $Script:NRAPIAuthenticationInformation) {
		throw "Missing NinjaOne authentication tokens, please run 'Connect-NinjaOne' first."
	}
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
