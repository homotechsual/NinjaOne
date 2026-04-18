function Remove-NinjaOneAssetRelationship {
	<#
		.SYNOPSIS
			Deletes an asset relationship.
		.DESCRIPTION
			Deletes an asset relationship using the NinjaOne v2 API.
		.FUNCTIONALITY
			Asset Relationship
		.EXAMPLE
			PS> Remove-NinjaOneAssetRelationship -relationId 1

			Deletes asset relationship 1.
		.OUTPUTS
			The API response indicating success or failure.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/assetrelationship
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
	[OutputType([Object])]
	[Alias('rnoar')]
	[MetadataAttribute(
		'/v2/itam/asset-relationship',
		'delete'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# Asset relationship ID.
		[Parameter(Mandatory, ValueFromPipelineByPropertyName)]
		[Int]$relationId
	)
	process {
		try {
			$Resource = ('v2/itam/asset-relationship?relationId={0}' -f $relationId)
			if ($PSCmdlet.ShouldProcess(('Asset Relationship {0}' -f $relationId), 'Delete')) {
				return (New-NinjaOneDELETERequest -Resource $Resource)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
