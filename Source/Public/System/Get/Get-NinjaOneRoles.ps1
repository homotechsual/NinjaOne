
function Get-NinjaOneRoles {
	<#
		.SYNOPSIS
			Gets device roles from the NinjaOne API.
		.DESCRIPTION
			Retrieves device roles from the NinjaOne v2 API.
		.FUNCTIONALITY
			Device Roles
		.EXAMPLE
			PS> Get-NinjaOneRoles

			Gets all device roles.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/deviceroles
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnor', 'Get-NinjaOneRole', 'gnodr', 'Get-NinjaOneDeviceRoles', 'Get-NinjaOneDeviceRole')]
	[MetadataAttribute(
		'/v2/roles',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param()
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			Write-Verbose 'Retrieving all roles.'
			$Resource = 'v2/roles'
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$RoleResults = New-NinjaOneGETRequest @RequestParams
			if ($RoleResults) {
				return $RoleResults
			} else {
				throw 'No roles found.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
