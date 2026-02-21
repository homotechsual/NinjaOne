function New-NinjaOneLocation {
	<#
		.SYNOPSIS
			Creates a new location using the NinjaOne API.
		.DESCRIPTION
			Create an location using the NinjaOne v2 API.
		.FUNCTIONALITY
			Location
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/location
	
	.EXAMPLE
		PS> $newObject = @{ Name = 'Example' }
		PS> New-NinjaOneLocation @newObject

		Creates a new resource with the specified properties.

	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnol')]
	[MetadataAttribute(
		'/v2/organization/{id}/locations',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The organization Id to use when creating the location.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id', 'organizationId')]
		[Int]$organisationId,
		# An object containing the location to create.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$location,
		# Show the location that was created.
		[Switch]$show
	)
	process {
		try {
			$Resource = ('v2/organization/{0}/locations' -f $organisationId)
			$RequestParams = @{
				Resource = $Resource
				Body = $location
			}
			if ($PSCmdlet.ShouldProcess(('Location {0}' -f $location.name), 'Create')) {
				$LocationCreate = New-NinjaOnePOSTRequest @RequestParams
				if ($show) {
					return $LocationCreate
				} else {
					Write-Information ('Location {0} created.' -f $LocationCreate.name)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
