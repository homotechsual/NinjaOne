function Get-NinjaOneUserRoles {
	<#
		.SYNOPSIS
			Gets user roles.
		.DESCRIPTION
			Retrieves all user roles via the NinjaOne v2 API.
		.FUNCTIONALITY
			Users
		.EXAMPLE
			PS> Get-NinjaOneUserRoles

			Gets all user roles.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/userroles
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnour')]
	[MetadataAttribute(
		'/v2/user/roles',
		'get'
	)]
	Param()
	process {
		try {
			return (New-NinjaOneGETRequest -Resource 'v2/user/roles')
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
