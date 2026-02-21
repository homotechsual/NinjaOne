function Set-NinjaOneNodeRoles {
	<#
		.SYNOPSIS
			Updates node roles in NinjaOne.
		.DESCRIPTION
			Updates node roles using the NinjaOne v2 API.
		.FUNCTIONALITY
			Node Roles
		.EXAMPLE
			PS> Set-NinjaOneNodeRoles -nodeRoles @(@{ id = 1; name = 'Role A' })

			Updates node roles from the provided payload.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/noderoles
	#>
	[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[MetadataAttribute(
		'/v2/noderole',
		'patch'
	)]
	param(
		# Node role payload to update.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$nodeRoles,
		# Show the updated node roles.
		[Switch]$show
	)
	process {
		try {
			$Resource = 'v2/noderole'
			$RequestParams = @{
				Resource = $Resource
				Body = $nodeRoles
			}
			if ($PSCmdlet.ShouldProcess('Node roles', 'Update')) {
				$NodeRoleUpdate = New-NinjaOnePATCHRequest @RequestParams
				if ($show) {
					return $NodeRoleUpdate
				}
				Write-Information 'Node roles updated.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
