function New-NinjaOneDELETERequest {
	<#
		.SYNOPSIS
			Builds a request for the NinjaOne API.
		.DESCRIPTION
			Wrapper function to build web requests for the NinjaOne API.
		.EXAMPLE
			Cancel the maintenance for device with id 1.

			PS ~> New-NinjaOneDELETERequest -Resource "/v2/device/1/maintenance"
		.OUTPUTS
			Outputs an object containing the response from the web request.
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Private function - no need to support.')]
	param (
		# The resource to send the request to.
		[Parameter(Mandatory = $True)]
		[String]$Resource
	)
	if ($null -eq $Script:NRAPIConnectionInformation) {
		throw "Missing NinjaOne connection information, please run 'Connect-NinjaOne' first."
	}
	if ($null -eq $Script:NRAPIAuthenticationInformation) {
		throw "Missing NinjaOne authentication tokens, please run 'Connect-NinjaOne' first."
	}
	try {
		if ($QSCollection) {
			Write-Verbose "Query string in New-NinjaOneDELETERequest contains: $($QSCollection | Out-String)"
			$QueryStringCollection = [System.Web.HTTPUtility]::ParseQueryString([String]::Empty)
			Write-Verbose 'Building [HttpQSCollection] for New-NinjaOneDELETERequest'
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
		$WebRequestParams = @{
			Method = 'DELETE'
			Uri = $RequestUri.ToString()
		}
		Write-Verbose "Building new NinjaOneRequest with params: $($WebRequestParams | Out-String)"
		try {
			$Result = Invoke-NinjaOneRequest @WebRequestParams
			Write-Verbose "NinjaOne request returned $($Result | Out-String)"
			if ($Result.results) {
				return $Result.results
			} elseif ($Result.result) {
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
