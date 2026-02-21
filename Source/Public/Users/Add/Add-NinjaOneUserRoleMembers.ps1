function Add-NinjaOneUserRoleMembers {
	<#
		.SYNOPSIS
			Adds members to a user role.
		.DESCRIPTION
			Adds one or more members to the specified user role via the NinjaOne v2 API.
		.FUNCTIONALITY
			Users
		.EXAMPLE
			PS> Add-NinjaOneUserRoleMembers -roleId 10 -members @{ userIds = @(1,2) }

			Adds users 1 and 2 to role 10.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/userrole-addmembers
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('anourm')]
	[MetadataAttribute(
		'/v2/user/role/{roleId}/add-members',
		'patch'
	)]
	param(
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Int]$roleId,
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$members
	)
	process {
		try {
			$res = 'v2/user/role/{0}/add-members' -f $roleId
		if ($PSCmdlet.ShouldProcess(('Role {0}' -f $roleId), 'Add Members')) {
			$Result = New-NinjaOnePATCHRequest -Resource $res -Body $members
			return $Result
		}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

