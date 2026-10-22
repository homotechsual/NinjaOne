function New-NinjaOneGETRequest {
	<#
		.SYNOPSIS
			Builds a request for the NinjaOne API.
		.DESCRIPTION
			Wrapper function to build web requests for the NinjaOne API. Automatically pages through
			multi-page responses (activity, cursor, after, and anchor style pagination) and returns the combined
			result set. An explicit `pageSize` controls each page, not the total number of results, and values
			above 1000 are capped at 1000 with a warning. Raw responses are returned without pagination.
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
		# A query string collection used to build the query string.
		[System.Collections.Specialized.NameValueCollection]$qSCollection,
		# return the raw response.
		[Switch]$raw,
		# Parse date/time values returned in JSON.
		[Switch]$parseDateTime,
		# The name of the query string parameter used to send the cursor for the next page of a `results`/`cursor` shaped response.
		[String]$cursorParameterName = 'cursor'
	)
	if ($null -eq $Script:NRAPIConnectionInformation) {
		throw "Missing NinjaOne connection information, please run 'Connect-NinjaOne' first."
	}
	if ($null -eq $Script:NRAPIAuthenticationInformation) {
		throw "Missing NinjaOne authentication tokens, please run 'Connect-NinjaOne' first."
	}
	Test-NinjaOneEndpointSupport -Method 'GET' -resource $resource -Verbose:$VerbosePreference | Out-Null
	try {
		$QueryStringCollection = [System.Collections.Specialized.NameValueCollection]::new()
		if ($qSCollection) {
			Write-Verbose ('Query string in New-NinjaOneGETRequest contains: {0}' -f ($qSCollection | Out-String))
			foreach ($Key in $qSCollection.Keys) {
				$Values = @($qSCollection.GetValues($Key))
				foreach ($Value in $Values) {
					$null = $QueryStringCollection.Add($Key, [String]$Value)
				}
			}
		} else {
			Write-Verbose 'Query string collection not present...'
		}
		if ($QueryStringCollection['pageSize'] -and [Int]$QueryStringCollection['pageSize'] -gt 1000) {
			Write-Warning ('Requested pageSize {0} exceeds the supported maximum of 1000; using 1000.' -f $QueryStringCollection['pageSize'])
			$QueryStringCollection.Set('pageSize', '1000')
		}
		try {
			# Aggregates pages for 'results'/'activities' shaped responses; cursor state tracked across iterations to detect the last page.
			$PageResults = [System.Collections.Generic.List[Object]]::new()
			$ResponseShape = $null
			$AccountLastActivityId = $null
			$AccountLastNodeActivityId = $null
			$SupportsAfterPagination = $resource -match '^/?v2/(organizations|organizations-detailed|devices|devices-detailed|locations|organization/[^/]+/devices)$'
			$AnchorParameterName = if ($resource -match '^/?v2/ticketing/app-user-contact$') {
				'anchorNaturalId'
			} elseif ($resource -match '^/?v2/ticketing/ticket/[^/]+/log-entry$') {
				'anchorId'
			}
			$AnchorPropertyName = if ($AnchorParameterName -eq 'anchorNaturalId') { 'naturalId' } elseif ($AnchorParameterName) { 'id' }
			$ContinuationPropertyName = if ($SupportsAfterPagination) { 'id' } elseif ($AnchorPropertyName) { $AnchorPropertyName }
			$Cursor = $QueryStringCollection[$cursorParameterName]
			$OlderThanCursor = $QueryStringCollection['olderThan']
			$AfterCursor = $QueryStringCollection['after']
			$AnchorCursor = if ($AnchorParameterName) { $QueryStringCollection[$AnchorParameterName] }
			$FetchNextPage = $true
			while ($FetchNextPage) {
				$RequestQueryStringCollection = [System.Collections.Specialized.NameValueCollection]::new()
				foreach ($Key in $QueryStringCollection.Keys) {
					$Values = @($QueryStringCollection.GetValues($Key))
					foreach ($Value in $Values) {
						$null = $RequestQueryStringCollection.Add($Key, [String]$Value)
					}
				}
				if ($Cursor) {
					$RequestQueryStringCollection.Set($cursorParameterName, [String]$Cursor)
				}
				if ($OlderThanCursor) {
					$RequestQueryStringCollection.Set('olderThan', [String]$OlderThanCursor)
				}
				if ($AfterCursor) {
					$RequestQueryStringCollection.Set('after', [String]$AfterCursor)
				}
				if ($AnchorCursor) {
					$RequestQueryStringCollection.Set($AnchorParameterName, [String]$AnchorCursor)
				}
				$QueryStringPairs = @()
				foreach ($Key in $RequestQueryStringCollection.AllKeys) {
					if ([string]::IsNullOrEmpty($Key)) { continue }
					foreach ($Value in @($RequestQueryStringCollection.GetValues($Key))) {
						$QueryStringPairs += ('{0}={1}' -f [System.Uri]::EscapeDataString([String]$Key), [System.Uri]::EscapeDataString([String]$Value))
					}
				}
				$RequestQueryString = if ($QueryStringPairs.Count -gt 0) { ($QueryStringPairs -join '&') } else { [String]::Empty }
				Write-Verbose ('URI is {0}' -f $Script:NRAPIConnectionInformation.URL)
				$RequestUri = [System.UriBuilder]$Script:NRAPIConnectionInformation.URL
				$RequestUri.Path = $resource
				if ($RequestQueryString) {
					$RequestUri.Query = $RequestQueryString
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
					Write-Verbose ('WebRequestParams contains: {0}' -f ($WebRequestParams | Out-String))
				} else {
					Write-Verbose 'WebRequestParams is empty.'
				}
				$Result = Invoke-NinjaOneRequest @WebRequestParams
				if (-not $Result) {
					Write-Verbose 'NinjaOne request returned nothing.'
					$FetchNextPage = $false
					break
				}
				Write-Verbose ('NinjaOne request returned:: {0}' -f ($Result | Out-String))
				if ($raw) {
					# Raw responses are returned as-is, on the first page, without pagination.
					return $Result
				}
				if (-not $ResponseShape) {
					$Properties = if ($Result -is [Array]) { @() } else { ($Result | Get-Member -MemberType 'NoteProperty').Name }
					$ResponseShape = if ($Properties -contains 'activities') {
						'activities'
					} elseif ($Properties -contains 'results') {
						'results'
					} elseif ($Properties -contains 'result') {
						'result'
					} elseif ($SupportsAfterPagination -or $AnchorParameterName -or $Result -is [Array]) {
						'array'
					} else {
						'raw'
					}
				}
				switch ($ResponseShape) {
					'activities' {
						Write-Verbose 'Paging ''activities'' shaped response using the last returned activity id.'
						$Page = @($Result.activities)
						$PageResults.AddRange($Page)
						if (-not $AccountLastActivityId) {
							# 'lastActivityId' is the account-wide latest activity id, not a per-page cursor, so it's captured once for the final return value.
							$AccountLastActivityId = $Result.lastActivityId
						}
						if (-not $AccountLastNodeActivityId) {
							$AccountLastNodeActivityId = $Result.lastNodeActivityId
						}
						$NextOlderThan = ($Page | Select-Object -Last 1).id
						if ($Page.Count -gt 0 -and $NextOlderThan -and ($NextOlderThan -ne $OlderThanCursor)) {
							$OlderThanCursor = $NextOlderThan
						} else {
							$FetchNextPage = $false
						}
					}
					'results' {
						Write-Verbose 'Paging ''results''/''cursor'' shaped response.'
						$Page = @($Result.results)
						$PageResults.AddRange($Page)
						$NextCursor = $Result.cursor.name
						if ($Page.Count -gt 0 -and $NextCursor -and ($NextCursor -ne $Cursor)) {
							$Cursor = $NextCursor
						} else {
							$FetchNextPage = $false
						}
					}
					'result' {
						return $Result.result
					}
					'array' {
						$Page = @($Result)
						$PageResults.AddRange($Page)
						$NextAnchor = if ($ContinuationPropertyName) { ($Page | Select-Object -Last 1).$ContinuationPropertyName }
						if ($SupportsAfterPagination -and $Page.Count -gt 0 -and $NextAnchor -and ($NextAnchor -ne $AfterCursor)) {
							$AfterCursor = $NextAnchor
						} elseif ($AnchorParameterName -and $Page.Count -gt 0 -and $NextAnchor -and ($NextAnchor -ne $AnchorCursor)) {
							$AnchorCursor = $NextAnchor
						} else {
							$FetchNextPage = $false
						}
					}
					default {
						return $Result
					}
				}
			}
			switch ($ResponseShape) {
				'activities' {
					Write-Verbose 'returning ''activities'' property.'
					$ActivityResponse = [ordered]@{
						lastActivityId = $AccountLastActivityId
						activities = $PageResults.ToArray()
					}
					if ($null -ne $AccountLastNodeActivityId) {
						$ActivityResponse.lastNodeActivityId = $AccountLastNodeActivityId
					}
					return [PSCustomObject]$ActivityResponse
				}
				'results' {
					Write-Verbose 'returning ''results'' property.'
					return $PageResults.ToArray()
				}
				'array' {
					return $PageResults.ToArray()
				}
				default {
					return $null
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
