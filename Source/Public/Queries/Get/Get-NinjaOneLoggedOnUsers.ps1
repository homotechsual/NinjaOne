function Get-NinjaOneLoggedOnUsers {
	<#
		.SYNOPSIS
			Gets the logged on users from the NinjaOne API.
		.DESCRIPTION
			Retrieves the logged on users from the NinjaOne v2 API.
		.FUNCTIONALITY
			Logged On Users Query
		.EXAMPLE
			PS> Get-NinjaOneLoggedOnUsers

			Gets all logged on users.
		.EXAMPLE
			PS> Get-NinjaOneLoggedOnUsers -deviceFilter 'org = 1'

			Gets the logged on users for the organisation with id 1.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/loggedonusersquery
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnolou', 'gnollou', 'gnollu', 'Get-NinjaOneLastLoggedOnUsers', 'Get-NinjaOneLastLoggedonUsers')]
	[MetadataAttribute(
		'/v2/queries/logged-on-users',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# Filter devices.
		[Parameter(Position = 0)]
		[Alias('df')]
		[String]$deviceFilter,
		# Cursor name.
		[Parameter(Position = 1)]
		[String]$cursor,
		# Number of results per page.
		[Parameter(Position = 2)]
		[Int]$pageSize
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			$Resource = 'v2/queries/logged-on-users'
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$LoggedOnUsers = New-NinjaOneGETRequest @RequestParams
			if ($LoggedOnUsers) {
				return $LoggedOnUsers
			} else {
				throw 'No logged on users found.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}