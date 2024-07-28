function Get-NinjaOneOrganisationLocations {
	<#
        .SYNOPSIS
            Wrapper command using `Get-NinjaOneLocations` to get locations for an organisation.
        .FUNCTIONALITY
            Organisation Locations
        .EXAMPLE
            Get-NinjaOneOrganisationLocations -organisationId 1

            Gets locations for the organisation with id 1.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationlocations
    #>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnool', 'Get-NinjaOneOrganizationLocations')]
	[MetadataAttribute()]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# Filter by organisation id.
		[Parameter(Mandatory, ParameterSetName = 'Single Organisation', Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id', 'organizationId')]
		[Int]$organisationId
	)
	begin {	}
	process {
		try {
			$OrganisationLocations = Get-NinjaOneLocations -organisationId $organisationId
			if ($OrganisationLocations) {
				return $OrganisationLocations
			} else {
				New-NinjaOneError -Message ('No locations found for the organisation with the id {0}.' -f $organisationId)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}