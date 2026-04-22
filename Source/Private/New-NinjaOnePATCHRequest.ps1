function New-NinjaOnePATCHRequest {
	<#
		.SYNOPSIS
			Builds a request for the NinjaOne API.
		.DESCRIPTION
			Wrapper function to build web requests for the NinjaOne API.
		.EXAMPLE
			Make a PATCH request to the custom fields endpoint for device 1.

			PS C:\> New-NinjaOnePATCHRequest -resource "/v2/device/1/custom-fields" -body @{"myCustomField" = "value"}
		.OUTPUTS
			Outputs an object containing the response from the web request.
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Private function - no need to support.')]
	param (
		# The resource to send the request to.
		[Parameter(Mandatory = $True)]
		[String]$resource,
		# A hashtable used to build the query string.
		[HashTable]$qSCollection,
		# A hashtable used to build the body of the request.
		[Parameter(Mandatory = $True)]
		[Object]$body,
		# Parse date/time values returned in JSON.
		[Switch]$parseDateTime
	)
	if ($null -eq $Script:NRAPIConnectionInformation) {
		throw "Missing NinjaOne connection information, please run 'Connect-NinjaOne' first."
	}
	if ($null -eq $Script:NRAPIAuthenticationInformation) {
		throw "Missing NinjaOne authentication tokens, please run 'Connect-NinjaOne' first."
	}
	Test-NinjaOneEndpointSupport -Method 'PATCH' -resource $resource -Verbose:$VerbosePreference
	try {
		if ($qSCollection) {
			Write-Verbose ('Query string in New-NinjaOnePATCHRequest contains: {0}' -f ($qSCollection | Out-String))
			$QueryStringCollection = [System.Web.HTTPUtility]::ParseQueryString([String]::Empty)
			Write-Verbose 'Building [HttpQSCollection] for New-NinjaOnePATCHRequest'
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
			Write-Verbose ('Query string is {0}' -f ($QueryStringCollection | Out-String))
			$RequestUri.Query = $QueryStringCollection
		} else {
			Write-Verbose 'Query string not present...'
		}
		$WebRequestParams = @{
			Method = 'PATCH'
			Uri = $RequestUri.ToString()
			Body = (ConvertTo-Json -InputObject $body -Depth 100)
		}
		if ($parseDateTime -or $Script:ParseDateTimes) {
			$WebRequestParams.ParseDateTime = $true
		}
		Write-Verbose ('Raw body is {0}' -f $WebRequestParams.Body)
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
