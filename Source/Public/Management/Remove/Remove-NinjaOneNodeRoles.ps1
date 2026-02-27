function Remove-NinjaOneNodeRoles {
	<#
		.SYNOPSIS
			Deletes node roles in NinjaOne.
		.DESCRIPTION
			Deletes node roles using the NinjaOne v2 API.
		.FUNCTIONALITY
			Node Roles
		.EXAMPLE
			PS> Remove-NinjaOneNodeRoles -nodeRoles @(@{ id = 1 })

			Deletes node roles from the provided payload.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				ids = @(
					0
				)
			}
			PS> Remove-NinjaOneNodeRoles -nodeRoles $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/noderoles
	#>
	[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[MetadataAttribute(
		'/v2/noderole/delete',
		'post'
	)]
	param(
		# Node role delete payload.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$nodeRoles,
		# Show the delete response.
		[Switch]$show
	)
	process {
		try {
			$Resource = 'v2/noderole/delete'
			$RequestParams = @{
				Resource = $Resource
				Body = $nodeRoles
			}
			if ($PSCmdlet.ShouldProcess('Node roles', 'Delete')) {
				$NodeRoleDelete = New-NinjaOnePOSTRequest @RequestParams
				if ($show) {
					return $NodeRoleDelete
				}
				Write-Information 'Node roles deleted.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}









