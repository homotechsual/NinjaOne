function Get-NinjaOneTags {
	<#
		.SYNOPSIS
			Gets all tags.
		.DESCRIPTION
			Retrieves all tags via the NinjaOne v2 API.
		.FUNCTIONALITY
			Asset Tags
		.EXAMPLE
			PS> Get-NinjaOneTags

			Gets all tags.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/tags
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnotags')]
	[MetadataAttribute(
		'/v2/tag',
		'get'
	)]
	param()
	process {
		try {
			$RequestParams = @{ Resource = 'v2/tag' }
			return (New-NinjaOneGETRequest @RequestParams)
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
