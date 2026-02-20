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
