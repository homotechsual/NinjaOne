function New-NinjaOnePUTRequest {
	<#
		.SYNOPSIS
			Builds a request for the NinjaOne API.
		.DESCRIPTION
			Wrapper function to build web requests for the NinjaOne API.
		.EXAMPLE
			PS C:\> New-NinjaOnePUTRequest -Resource "/v2/organizations -Body @{"name"="MyOrg"}
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
		[HashTable]$QSCollection,
		# A hashtable used to build the body of the request.
		[Parameter(Mandatory = $True)]
		[Object]$Body,
		# Force body to an array.
		[Switch]$AsArray
	)
	if ($null -eq $Script:NRAPIConnectionInformation) {
		throw "Missing NinjaOne connection information, please run 'Connect-NinjaOne' first."
	}
	if ($null -eq $Script:NRAPIAuthenticationInformation) {
		throw "Missing NinjaOne authentication tokens, please run 'Connect-NinjaOne' first."
	}
	try {
		if ($QSCollection) {
			Write-Verbose "Query string in New-NinjaOnePUTRequest contains: $($QSCollection | Out-String)"
			$QueryStringCollection = [System.Web.HTTPUtility]::ParseQueryString([String]::Empty)
			Write-Verbose 'Building [HttpQSCollection] for New-NinjaOnePUTRequest'
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
			Write-Verbose "Query string is $($QueryStringCollection | Out-String)"
			$RequestUri.Query = $QueryStringCollection
		} else {
			Write-Verbose 'Query string not present...'
		}
		$WebRequestParams = @{
			Method = 'PUT'
			Uri = $RequestUri.ToString()
		}
		if ($Body) {
			Write-Verbose 'Building [HttpBody] for New-NinjaOnePUTRequest'
			if ($AsArray) {
				Write-Verbose 'Forcing body to array'
				$WebRequestParams.Body = (ConvertTo-Json -InputObject @($Body) -Depth 100)
			} else {
				Write-Verbose 'Not forcing body to array'
				$WebRequestParams.Body = (ConvertTo-Json -InputObject $Body -Depth 100)
			}
			Write-Verbose "Raw body is $($WebRequestParams.Body)"
		} else {
			Write-Verbose 'No body provided for New-NinjaOnePUTRequest'
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