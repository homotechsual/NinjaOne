function Set-NinjaOneUserRoleOrganizationPermissions {
	<#
		.SYNOPSIS
			Updates organization permissions for a user role.
		.DESCRIPTION
			Updates organization permissions for the specified user role via the NinjaOne v2 API.
		.FUNCTIONALITY
			User Role Permissions
		.EXAMPLE
			PS> Set-NinjaOneUserRoleOrganizationPermissions -roleId 10 -permissions @{ allowAll = $true }

			Updates organization permissions for role 10.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/userrole-organizationpermissions
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snourporg')]
	[MetadataAttribute(
		'/v2/user/role/{roleId}/permissions/organizations',
		'patch'
	)]
	param(
		# The user role ID to update permissions for.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Int]$roleId,
		# The organization permissions payload.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$permissions
	)
	process {
		try {
			$Resource = ('v2/user/role/{0}/permissions/organizations' -f $roleId)
			$RequestParams = @{ Resource = $Resource; Body = $permissions }
			if ($PSCmdlet.ShouldProcess(('Role {0}' -f $roleId), 'Update Organization Permissions')) {
				$Result = New-NinjaOnePATCHRequest @RequestParams
				return $Result
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
