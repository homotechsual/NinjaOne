function Get-NinjaOneOrganisationLocationsBackupUsage {
	<#
        .SYNOPSIS
            Wrapper command using `Get-NinjaOneLocationBackupUsage` to get backup usage for all locations in an organisation.
        .FUNCTIONALITY
            Organisation Locations Backup Usage
        .EXAMPLE
            Get-NinjaOneLocationBackupUsage -organisationId 1

            Gets backup usage for all locations for the organisation with id 1.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationlocationsbackupusage
    #>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnoolbu', 'Get-NinjaOneOrganizationLocationsBackupUsage')]
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
			$OrganisationLocationsBackupUsage = Get-NinjaOneLocationBackupUsage -organisationId $organisationId
			if ($OrganisationLocationsBackupUsage) {
				return $OrganisationLocationsBackupUsage
			} else {
				New-NinjaOneError -Message ('No backup usage found for the organisation with the id {0}.' -f $organisationId)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}