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
		# A query string collection used to build the query string.
		[System.Collections.Specialized.NameValueCollection]$qSCollection,
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
	Test-NinjaOneEndpointSupport -Method 'PATCH' -resource $resource -Verbose:$VerbosePreference | Out-Null
	try {
		if ($qSCollection) {
			Write-Verbose ('Query string parameter names: {0}' -f (@($qSCollection.Keys) -join ', '))
			$QueryStringCollection = $qSCollection
		} else {
			Write-Verbose 'Query string collection not present...'
		}
		Write-Verbose 'Using the configured NinjaOne API URL.'
		$RequestUri = [System.UriBuilder]$Script:NRAPIConnectionInformation.URL
		Write-Verbose ('Path is {0}' -f $resource)
		$RequestUri.Path = $resource
		if ($QueryStringCollection) {
			Write-Verbose ('Query string parameter names: {0}' -f (@($QueryStringCollection.Keys) -join ', '))
			$RequestUri.Query = $QueryStringCollection.ToString()
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
		Write-Verbose ('Request body values omitted; building {0} request.' -f $WebRequestParams.Method)
		try {
			$Result = Invoke-NinjaOneRequest @WebRequestParams
			Write-Verbose 'NinjaOne request returned a response.'
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
