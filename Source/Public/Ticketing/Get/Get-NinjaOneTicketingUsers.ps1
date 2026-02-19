function Get-NinjaOneTicketingUsers {
	<#
		.SYNOPSIS
			Gets lists of users from the NinjaOne API.
		.DESCRIPTION
			Retrieves lists of ticketing users  from the NinjaOne v2 API.
		.FUNCTIONALITY
			Ticketing Users
		.EXAMPLE
			PS> Get-NinjaOneTicketingUsers

			Gets all ticketing users. Contacts, end users and technicians.
		.EXAMPLE
			PS> Get-NinjaOneTicketingUsers -anchorNaturalId 10

			Starts the list of users from the user with the natural id 10.
		.EXAMPLE
			PS> Get-NinjaOneTicketingUsers -clientId 1

			Gets all users for the organisation with id 1.
		.EXAMPLE
			PS> Get-NinjaOneTicketingUsers -pageSize 10

			Limits the number of users returned to 10.
		.EXAMPLE
			PS> Get-NinjaOneTicketingUsers -searchCriteria 'mikey@homotechsual.dev'

			Searches for the user with the email address 'mikey@homotechsual.dev'.
		.EXAMPLE
			PS> Get-NinjaOneTicketingUsers -userType TECHNICIAN

			Gets all technician users.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/ticketingusers
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnotu')]
	[MetadataAttribute(
		'/v2/ticketing/app-user-contact',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# Start results from this user natural id.
		[Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Int]$anchorNaturalId,
		# Get users for this organisation id.
		[Parameter(Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id', 'organizationId')]
		[Int]$clientId,
		# The number of results to return.
		[Parameter(Position = 2)]
		[Int]$pageSize,
		# The search criteria to apply to the request.
		[Parameter(Position = 3)]
		[String]$searchCriteria,
		# Filter by user type. This can be one of "TECHNICIAN", "END_USER" or "CONTACT".
		[Parameter(Position = 4)]
		[ValidateSet('TECHNICIAN', 'END_USER', 'CONTACT')]
		[String]$userType

	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			$Resource = 'v2/ticketing/app-user-contact'
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$TicketingUsers = New-NinjaOneGETRequest @RequestParams
			if ($TicketingUsers) {
				return $TicketingUsers
			} else {
				throw 'No ticketing users found.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
