function Get-TokenExpiry {
	<#
	.SYNOPSIS
		Calculates and returns the expiry date/time of an access token.
	.DESCRIPTION
		Takes the expires in time for an auth token and returns a PowerShell date/time object containing the expiry date/time of the token.
	.OUTPUTS
		[System.DateTime]

		A powershell date/time object representing the token expiry.
	#>
	[CmdletBinding()]
	[OutputType([DateTime])]
	param (
		# Timestamp value for token expiry. e.g 3600
		[Parameter(
			Mandatory = $True
		)]
		[int64]$expiresIn
	)
	$Now = Get-Date
	$ExpiryDateTime = $Now.AddSeconds($expiresIn)
	Write-Verbose ('Calculated token expiry as {0}' -f $ExpiryDateTime)
	return $ExpiryDateTime
}
