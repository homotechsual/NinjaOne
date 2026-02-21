
function Get-NinjaOneUsers {
	<#
		.SYNOPSIS
			Gets users from the NinjaOne API.
		.DESCRIPTION
			Retrieves users from the NinjaOne v2 API.
		.FUNCTIONALITY
			Users
		.EXAMPLE
			PS> Get-NinjaOneUsers

			Gets all users.
		.EXAMPLE
			PS> Get-NinjaOneUsers -includeRoles

			Gets all users including information about their roles.
		.EXAMPLE
			PS> Get-NinjaOneUsers -userType TECHNICIAN

			Gets all technicians (users with the TECHNICIAN user type).
		.EXAMPLE
			PS> Get-NinjaOneUsers -organisationId 1

			Gets all users for the organisation with id 1 (only works for users with the END_USER user type).
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/users
	#>
	[CmdletBinding(DefaultParameterSetName = 'Default')]
	[OutputType([Object])]
	[Alias('gnou')]
	[MetadataAttribute(
		'/v2/users',
		'get',
		'/v2/organization/{id}/end-users',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# Get users for this organisation id.
		[Parameter(Mandatory, ParameterSetName = 'Organisation', Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id', 'organizationId')]
		[Int]$organisationId,
		# Filter by user type. This can be one of "TECHNICIAN" or "END_USER".
		[Parameter(ParameterSetName = 'Default', Position = 1, ValueFromPipelineByPropertyName)]
		[Parameter(ParameterSetName = 'Organisation', Position = 1, ValueFromPipelineByPropertyName)]
		[ValidateSet(
			'TECHNICIAN',
			'END_USER'
		)]
		[String]$userType,
		# Include roles in the response.
		[Parameter(ParameterSetName = 'Default', Position = 2, ValueFromPipelineByPropertyName)]
		[Parameter(ParameterSetName = 'Organisation', Position = 2, ValueFromPipelineByPropertyName)]
		[Switch]$includeRoles
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		# Workaround to prevent the query string processor from adding an 'organisationid=' parameter by removing it from the set parameters.
		if ($organisationId) {
			$Parameters.Remove('organisationId') | Out-Null
		}
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			if ($organisationId) {
				Write-Verbose ('Getting users for organisation {0}.' -f $organisationId)
				$Resource = ('v2/organization/{0}/end-users' -f $organisationId)
			} else {
				Write-Verbose 'Retrieving all users.'
				$Resource = 'v2/users'
			}
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$UserResults = New-NinjaOneGETRequest @RequestParams
			if ($UserResults) {
				return $UserResults
			} else {
				if ($organisationId) {
					throw ('No users found for organisation {0}.' -f $organisationId)
				} else {
					throw 'No users found.'
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
