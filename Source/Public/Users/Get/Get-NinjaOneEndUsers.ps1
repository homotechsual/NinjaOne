function Get-NinjaOneEndUsers {
	<#
		.SYNOPSIS
			Gets all end users.
		.DESCRIPTION
			Retrieves all end users via the NinjaOne v2 API.
		.FUNCTIONALITY
			Users
		.EXAMPLE
			PS> Get-NinjaOneEndUsers

			Gets all end users.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/endusers
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnoeus')]
	[MetadataAttribute(
		'/v2/user/end-users',
		'get'
	)]
	Param()
	process {
		try {
			$Resource = 'v2/user/end-users'
			$RequestParams = @{ Resource = $Resource }
			$Results = New-NinjaOneGETRequest @RequestParams
			if ($Results) { return $Results } else { throw 'No end users found.' }
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

