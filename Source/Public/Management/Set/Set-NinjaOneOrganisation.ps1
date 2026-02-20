function Set-NinjaOneOrganisation {
	<#
		.SYNOPSIS
			Sets organisation information, like name, node approval mode etc.
		.DESCRIPTION
			Sets organisation information using the NinjaOne v2 API.
		.FUNCTIONALITY
			Organisation
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/organisation
	
	.EXAMPLE
		PS> Set-NinjaOneOrganisation -Identity 123 -Property 'Value'

		Updates the specified resource.

	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snoo', 'Set-NinjaOneOrganization', 'unoo', 'Update-NinjaOneOrganisation', 'Update-NinjaOneOrganization')]
	[MetadataAttribute(
		'/v2/organization/{id}',
		'patch'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The organisation to set the information for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id', 'organizationId')]
		[Int]$organisationId,
		# The organisation information body object.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('organizationInformation', 'body')]
		[Object]$organisationInformation
	)
	process {
		try {
			Write-Verbose ('Setting organisation information for organisation {0}.' -f $organisationId)
			$Resource = ('v2/organization/{0}' -f $organisationId)
			$RequestParams = @{
				Resource = $Resource
				Body = $organisationInformation
			}
			if ($PSCmdlet.ShouldProcess(('Organisation {0} information' -f $organisationId), 'Update')) {
				$OrganisationUpdate = New-NinjaOnePATCHRequest @RequestParams
				if ($OrganisationUpdate -eq 204) {
					Write-Information ('Organisation {0} information updated successfully.' -f $organisationId)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
