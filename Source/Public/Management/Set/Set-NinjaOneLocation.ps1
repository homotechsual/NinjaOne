function Set-NinjaOneLocation {
	<#
		.SYNOPSIS
			Sets location information, like name, address, description etc.
		.DESCRIPTION
			Sets location information using the NinjaOne v2 API.
		.FUNCTIONALITY
			Location
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/location
	
	.EXAMPLE
		PS> Set-NinjaOneLocation -Identity 123 -Property 'Value'

		Updates the specified resource.

	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snol', 'unol', 'Update-NinjaOneLocation')]
	[MetadataAttribute(
		'/v2/organization/{id}/locations/{locationId}',
		'patch'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The organisation to set the location information for.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('id', 'organizationId')]
		[Int]$organisationId,
		# The location to set the information for.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Int]$locationId,
		# The location information body object.
		[Parameter(Mandatory, Position = 2, ValueFromPipelineByPropertyName)]
		[Object]$locationInformation
	)
	process {
		try {
			Write-Verbose ('Setting location information for location {0}.' -f $locationId)
			$Resource = ('v2/organization/{0}/locations/{1}' -f $organisationId, $locationId)
			$RequestParams = @{
				Resource = $Resource
				Body = $locationInformation
			}
			if ($PSCmdlet.ShouldProcess(('Location information for {0} in {1}' -f $locationId, $organisationId), 'Update')) {
				$LocationUpdate = New-NinjaOnePATCHRequest @RequestParams
				if ($LocationUpdate -eq 204) {
					Write-Information ('Location {0} information updated successfully.' -f $locationId)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
