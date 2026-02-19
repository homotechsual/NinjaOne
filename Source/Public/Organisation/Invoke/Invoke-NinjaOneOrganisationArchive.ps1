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

