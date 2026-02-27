function Invoke-NinjaOneOrganisationArchive {
	<#
		.SYNOPSIS
			Archives organisations.
		.DESCRIPTION
			Archives one or more organisations via the NinjaOne v2 API.
		.FUNCTIONALITY
			Organisation
		.EXAMPLE
			PS> Invoke-NinjaOneOrganisationArchive -archiveRequest @{ organizationIds = @(1,2,3) }

			Archives organisations 1, 2 and 3.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				clientChecklistIds = @(
					0
				)
			}
			PS> Invoke-NinjaOneOrganisationArchive -archiveRequest $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			Status code or archive result per API.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/organisation-archive
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('inOOA')]
	[MetadataAttribute(
		'/v2/organization/archive',
		'post'
	)]
	param(
		# Archive request payload per API schema
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$archiveRequest
	)
	process {
		try {
			$Resource = 'v2/organization/archive'
			$RequestParams = @{ Resource = $Resource; Body = $archiveRequest }
			if ($PSCmdlet.ShouldProcess('Organisations', 'Archive')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}










