function New-NinjaOneNodeRoles {
	<#
		.SYNOPSIS
			Creates node roles in NinjaOne.
		.DESCRIPTION
			Creates node roles using the NinjaOne v2 API.
		.FUNCTIONALITY
			Node Roles
		.EXAMPLE
			PS> New-NinjaOneNodeRoles -nodeRoles @(@{ name = 'Role A' })

			Creates node roles from the provided payload.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/noderoles
	#>
	[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[MetadataAttribute(
		'/v2/noderole',
		'post'
	)]
	param(
		# Node role payload to create.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$nodeRoles,
		# Show the created node roles.
		[Switch]$show
	)
	process {
		try {
			$Resource = 'v2/noderole'
			$RequestParams = @{
				Resource = $Resource
				Body = $nodeRoles
			}
			if ($PSCmdlet.ShouldProcess('Node roles', 'Create')) {
				$NodeRoleCreate = New-NinjaOnePOSTRequest @RequestParams
				if ($show) {
					return $NodeRoleCreate
				}
				Write-Information 'Node roles created.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
