function Get-NinjaOneOrganisationUsers {
	<#
        .SYNOPSIS
            Wrapper command using `Get-NinjaOneDevices` to get devices for an organisation.
		.DESCRIPTION
			Gets devices for an organisation using the NinjaOne v2 API.
        .FUNCTIONALITY
            Organisation Devices
        .EXAMPLE
            PS> Get-NinjaOneOrganisationDevices -organisationId 1

            Gets devices for the organisation with id 1.
		.EXAMPLE
			PS> Get-NinjaOneOrganisationDevices -organisationId 1 -after 10

			Gets devices for the organisation with id 1 starting from device id 10.
		.EXAMPLE
			PS> Get-NinjaOneOrganisationDevices -organisationId 1 -pageSize 10

			Gets 10 devices for the organisation with id 1.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/organisationdevices
    #>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnood', 'Get-NinjaOneOrganizationDevices')]
	[MetadataAttribute()]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# Filter by organisation id.
		[Parameter(Mandatory, ParameterSetName = 'Single Organisation', Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id', 'organizationId')]
		[Int]$organisationId,
		# Start results from device id.
		[Parameter(ParameterSetName = 'Single Organisation', Position = 1)]
		[Int]$after,
		# Number of results per page.
		[Parameter(ParameterSetName = 'Single Organisation', Position = 2)]
		[Int]$pageSize
	)
	begin {	}
	process {
		try {
			$OrganisationRequestParams = @{}
			if ($organisationId) {
				$OrganisationRequestParams.Add('organisationId', $organisationId)
			}
			if ($after) {
				$OrganisationRequestParams.Add('after', $after)
			}
			if ($pageSize) {
				$OrganisationRequestParams.Add('pageSize', $pageSize)
			}
			$OrganisationDevices = Get-NinjaOneDevices @OrganisationRequestParams
			if ($OrganisationDevices) {
				return $OrganisationDevices
			} else {
				New-NinjaOneError -Message ('No devices found for the organisation with the id {0}.' -f $organisationId)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}