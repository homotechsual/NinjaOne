function New-NinjaOneAssetRelationship {
	<#
		.SYNOPSIS
			Creates an asset relationship.
		.DESCRIPTION
			Creates a new asset relationship using the NinjaOne v2 API.
		.FUNCTIONALITY
			Asset Relationship
		.EXAMPLE
			PS> New-NinjaOneAssetRelationship -assetRelationship @{ entityId = 1; relEntityId = 2 }

			Creates an asset relationship.
		.OUTPUTS
			A PowerShell object containing the created relationship.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/assetrelationship
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnoar')]
	[MetadataAttribute(
		'/v2/itam/asset-relationship',
		'post'
	)]
	param(
		# Asset relationship payload per API schema.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$assetRelationship
	)
	process {
		try {
			$Resource = 'v2/itam/asset-relationship'
			$RequestParams = @{ Resource = $Resource; Body = $assetRelationship }
			if ($PSCmdlet.ShouldProcess('Asset Relationship', 'Create')) {
				return (New-NinjaOnePOSTRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
