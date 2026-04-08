function Get-NinjaOneAssetRelationships {
	<#
		.SYNOPSIS
			Gets asset relationships.
		.DESCRIPTION
			Retrieves asset relationships for all supported entities or for a specific entity from the NinjaOne v2 API.
		.FUNCTIONALITY
			Asset Relationships
		.EXAMPLE
			PS> Get-NinjaOneAssetRelationships

			Gets all available asset relationships.
		.EXAMPLE
			PS> Get-NinjaOneAssetRelationships -EntityType DEVICE -EntityId 1

			Gets asset relationships for the specified entity.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/assetrelationships
	#>
	[CmdletBinding(DefaultParameterSetName = 'All')]
	[OutputType([Object])]
	[Alias('gnoars')]
	[MetadataAttribute(
		'/v2/itam/asset-relationship/relations',
		'get',
		'/v2/itam/asset-relationship/{entityType}/{entityId}/relations',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The related entity type.
		[Parameter(Mandatory, ParameterSetName = 'ByEntity', ValueFromPipelineByPropertyName)]
		[String]$EntityType,
		# The related entity ID.
		[Parameter(Mandatory, ParameterSetName = 'ByEntity', ValueFromPipelineByPropertyName)]
		[Int]$EntityId
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			if ($PSCmdlet.ParameterSetName -eq 'ByEntity') {
				$Resource = ('v2/itam/asset-relationship/{0}/{1}/relations' -f $EntityType, $EntityId)
			} else {
				$Resource = 'v2/itam/asset-relationship/relations'
			}

			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$Results = New-NinjaOneGETRequest @RequestParams
			if ($Results) {
				return $Results
			} else {
				throw 'No asset relationships found.'
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
