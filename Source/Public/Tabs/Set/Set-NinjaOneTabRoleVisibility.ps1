function Set-NinjaOneTabRoleVisibility {
	<#
		.SYNOPSIS
			Sets tab visibility for a role.
		.DESCRIPTION
			Configures tab visibility for a specific role via the NinjaOne v2 API.
		.FUNCTIONALITY
			Tabs
		.EXAMPLE
			PS> Set-NinjaOneTabRoleVisibility -roleId 10 -visibility @(
				@{ tabId = 1; visible = $true },
				@{ tabId = 2; visible = $false }
			)

			Sets visibility for tabs on role 10.
		.OUTPUTS
			Updated visibility data per API.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/tab-role-visibility
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snotabrv')]
	[MetadataAttribute(
		'/v2/tab/role/{roleId}/visibility',
		'patch'
	)]
	param(
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Int]$roleId,
		# Array payload (CustomTabsVisibilityPublicApiDTO[])
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$visibility
	)
	process {
		try {
			$Resource = ('v2/tab/role/{0}/visibility' -f $roleId)
			$RequestParams = @{ Resource = $Resource; Body = $visibility }
			if ($PSCmdlet.ShouldProcess(('Role {0}' -f $roleId), 'Set Tab Visibility')) {
				$Result = New-NinjaOnePATCHRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

