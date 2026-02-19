function Get-NinjaOneOrganisationEndUsers {
	<#
		.SYNOPSIS
			Gets end users for an organisation.
		.DESCRIPTION
			Returns list of end users for a specific organisation via the NinjaOne v2 API.
		.FUNCTIONALITY
			Organisation
		.EXAMPLE
			PS> Get-NinjaOneOrganisationEndUsers -organisationId 1 -includeRoles

			Gets end users for organisation 1 including roles.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisation-endusers
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnooeu','Get-NinjaOneOrganizationEndUsers')]
	[MetadataAttribute(
		'/v2/organization/{id}/end-users',
		'get'
	)]
	param(
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('organizationId')]
		[Int]$organisationId,
		# Includes user role information
		[Parameter(Position = 1)]
		[Switch]$includeRoles
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		if ($organisationId) { $Parameters.Remove('organisationId') | Out-Null }
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			$Resource = ('v2/organization/{0}/end-users' -f $organisationId)
			$RequestParams = @{ Resource = $Resource; QSCollection = $QSCollection }
			$Results = New-NinjaOneGETRequest @RequestParams
			if ($Results) { return $Results } else { throw ('No end users found for organisation {0}.' -f $organisationId) }
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

