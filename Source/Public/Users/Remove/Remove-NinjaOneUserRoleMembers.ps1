function Remove-NinjaOneUserRoleMembers {
	<#
		.SYNOPSIS
			Removes members from a user role.
		.DESCRIPTION
			Removes one of more members from the specified user role via the NinjaOne v2 API.
		.FUNCTIONALITY
			Users
		.EXAMPLE
			PS> Remove-NinjaOneUserRoleMembers -roleId 10 -members @{ userIds = @(1,2) } -Confirm:$false

			Removes users 1 and 2 from role 10.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/userrole-removemembers
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('rnourm')]
	[MetadataAttribute(
		'/v2/user/role/{roleId}/remove-members',
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
			$res = 'v2/user/role/{0}/remove-members' -f $roleId
		if ($PSCmdlet.ShouldProcess(('Role {0}' -f $roleId), 'Remove Members')) {
			$Result = New-NinjaOnePATCHRequest -Resource $res -Body $members
			return $Result
		}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

