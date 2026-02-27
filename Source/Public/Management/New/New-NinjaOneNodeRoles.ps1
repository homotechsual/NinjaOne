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
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @(
				@{
					nodeRoleParentId = 0
					icon = "string"
					nodeClass = "WINDOWS_SERVER"
					name = "string"
					description = "string"
					nodeRoleParentName = "string"
					chassisType = "UNKNOWN"
				}
			)
			PS> New-NinjaOneNodeRoles -nodeRoles $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
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





