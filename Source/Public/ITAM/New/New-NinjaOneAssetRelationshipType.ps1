function New-NinjaOneAssetRelationshipType {
	<#
		.SYNOPSIS
			Creates an asset relationship type.
		.DESCRIPTION
			Creates a new asset relationship type using the NinjaOne v2 API.
		.FUNCTIONALITY
			Asset Relationship Type
		.EXAMPLE
			PS> New-NinjaOneAssetRelationshipType -relationshipType @{ name = 'Depends On' }

			Creates an asset relationship type.
		.OUTPUTS
			A PowerShell object containing the created relationship type.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/assetrelationshiptype
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnoart')]
	[MetadataAttribute(
		'/v2/itam/asset-relationship/types',
		'post'
	)]
	param(
		# Asset relationship type payload per API schema.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$relationshipType
	)
	process {
		try {
			$Resource = 'v2/itam/asset-relationship/types'
			$RequestParams = @{ Resource = $Resource; Body = $relationshipType }
			if ($PSCmdlet.ShouldProcess('Asset Relationship Type', 'Create')) {
				return (New-NinjaOnePOSTRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
