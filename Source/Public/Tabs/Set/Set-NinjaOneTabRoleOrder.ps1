function Set-NinjaOneTabRoleOrder {
	<#
		.SYNOPSIS
			Updates the order of custom tabs for a specific role.
		.DESCRIPTION
			Updates the order of custom tabs for a role via the NinjaOne v2 API. NOTE: Only tabs created on this role can be ordered. All tabs on the role must be specified.
		.FUNCTIONALITY
			Tabs
		.EXAMPLE
			PS> Set-NinjaOneTabRoleOrder -roleId 10 -order @(
				@{ tabId = 1; order = 1 },
				@{ tabId = 2; order = 2 }
			)

			Sets the role tabs order for role 10.
		.OUTPUTS
			Updated order data per API.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/tab-role-order
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snotabro')]
	[MetadataAttribute(
		'/v2/tab/role/{roleId}/order',
		'patch'
	)]
	param(
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Int]$roleId,
		# Array payload specifying the tab ordering (CustomTabsOrderPublicApiDTO[])
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$order
	)
	process {
		try {
			$Resource = ('v2/tab/role/{0}/order' -f $roleId)
			$RequestParams = @{ Resource = $Resource; Body = $order }
			if ($PSCmdlet.ShouldProcess(('Role {0}' -f $roleId), 'Update Tab Order')) {
				$Result = New-NinjaOnePATCHRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

