function Get-NinjaOneAssetRelationshipTypes {
	<#
		.SYNOPSIS
			Gets asset relationship types.
		.DESCRIPTION
			Retrieves asset relationship types from the NinjaOne v2 API.
		.FUNCTIONALITY
			Asset Relationship Types
		.EXAMPLE
			PS> Get-NinjaOneAssetRelationshipTypes

			Gets all asset relationship types.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/assetrelationshiptypes
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnoarts')]
	[MetadataAttribute(
		'/v2/itam/asset-relationship/types',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param()
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			$RequestParams = @{
				Resource = 'v2/itam/asset-relationship/types'
				QSCollection = $QSCollection
			}
			$Results = New-NinjaOneGETRequest @RequestParams
			if ($Results) {
				return $Results
			} else {
				throw 'No asset relationship types found.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
