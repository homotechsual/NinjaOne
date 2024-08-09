function Get-NinjaOneOrganisationInformation {
	<#
        .SYNOPSIS
            Wrapper command using `Get-NinjaOneOrganisations` to get detailed information for an organisation.
		.DESCRIPTION
			Gets detailed information for an organisation using the NinjaOne v2 API.
        .FUNCTIONALITY
            Organisation Information
        .EXAMPLE
            Get-NinjaOneOrganisationInformation -organisationId 1

            Gets detailed information for the organisation with id 1.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationinformation
    #>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnooi', 'Get-NinjaOneOrganizationInformation')]
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
			$OrganisationInformation = Get-NinjaOneOrganisations -organisationId $organisationId
			if ($OrganisationInformation) {
				return $OrganisationInformation
			} else {
				New-NinjaOneError -Message ('No organisation found with the id {0}.' -f $organisationId)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}