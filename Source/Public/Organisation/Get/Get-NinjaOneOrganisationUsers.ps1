function Get-NinjaOneOrganisationUsers {
	<#
        .SYNOPSIS
            Wrapper command using `Get-NinjaOneUsers` to get users for an organisation.
        .FUNCTIONALITY
            Organisation Users
        .EXAMPLE
            Get-NinjaOneOrganisationUsers -organisationId 1

            Gets users for the organisation with id 1.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationusers
    #>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnoou', 'Get-NinjaOneOrganizationUsers')]
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
			$OrganisationUsers = Get-NinjaOneUsers -organisationId $organisationId
			if ($OrganisationUsers) {
				return $OrganisationUsers
			} else {
				New-NinjaOneError -Message ('No users found for the organisation with the id {0}.' -f $organisationId)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}