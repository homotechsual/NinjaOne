function Get-NinjaOneTechnicians {
	<#
		.SYNOPSIS
			Gets all technicians.
		.DESCRIPTION
			Retrieves all technicians via the NinjaOne v2 API.
		.FUNCTIONALITY
			Users
		.EXAMPLE
			PS> Get-NinjaOneTechnicians

			Gets all technicians.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/technicians
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnotecs')]
	[MetadataAttribute(
		'/v2/user/technicians',
		'get'
	)]
	Param()
	process {
		try {
			$Resource = 'v2/user/technicians'
			$RequestParams = @{ Resource = $Resource }
			$Results = New-NinjaOneGETRequest @RequestParams
			if ($Results) {
				return $Results
			} else {
				throw 'No technicians found.'
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

