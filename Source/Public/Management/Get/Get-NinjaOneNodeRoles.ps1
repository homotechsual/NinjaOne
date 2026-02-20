function Get-NinjaOneNodeRoles {
	<#
		.SYNOPSIS
			Gets node roles from the NinjaOne API.
		.DESCRIPTION
			Retrieves node roles using the NinjaOne v2 API.
		.FUNCTIONALITY
			Node Roles
		.EXAMPLE
			PS> Get-NinjaOneNodeRoles

			Gets all node roles.
		.EXAMPLE
			PS> Get-NinjaOneNodeRoles -isAssignable

			Gets node roles that are assignable.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/noderoles
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[MetadataAttribute(
		'/v2/noderole/list',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# Return only assignable node roles.
		[Parameter(Position = 0)]
		[Alias('assignable')]
		[Switch]$isAssignable
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			$Resource = 'v2/noderole/list'
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$NodeRoleResults = New-NinjaOneGETRequest @RequestParams
			return $NodeRoleResults
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
