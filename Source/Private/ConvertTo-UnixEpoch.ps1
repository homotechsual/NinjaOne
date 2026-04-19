function ConvertTo-UnixEpoch {
	<#
	.SYNOPSIS
		Converts a PowerShell DateTime object to a Unix Epoch timestamp.
	.DESCRIPTION
		Takes a PowerShell DateTime object and returns a Unix Epoch timestamp representing the same date/time.
	.OUTPUTS
		[System.Int]

		The Unix Epoch timestamp.
	#>
	[CmdletBinding()]
	[OutputType([Int], [Int64])]
	param (
		# The PowerShell DateTime object to convert.
		[Parameter(
			Mandatory = $True
		)]
		[Object]$dateTime,
		[Alias("Millis", "Ms")]
		[switch]$milliseconds
	)
	if ($dateTime -is [String]) {
		$dateTime = [DateTime]::Parse($dateTime)
	} elseif ($dateTime -is [Int]) {
		$dateTime = (Get-Date 01.01.1970).AddSeconds($dateTime)
	} elseif ($dateTime -is [DateTime]) {
		$dateTime = $dateTime
	} else {
		Write-Error 'The DateTime parameter must be a DateTime object, a string, or an integer.'
		exit 1
	}
	$UniversalDateTime = $dateTime.ToUniversalTime()
	$UnixEpochTimestamp = Get-Date -Date $UniversalDateTime -UFormat %s

	if ($milliseconds) {
		$UnixEpochTimestamp = [Int64]$UnixEpochTimestamp * 1000
	}

	Write-Verbose "Converted $dateTime to Unix Epoch timestamp $UnixEpochTimestamp"
	return $UnixEpochTimestamp
}
