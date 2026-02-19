function Get-NinjaOneEntityCustomFieldsSignedURLs {
	<#
		.SYNOPSIS
			Gets signed URLs for custom fields on an entity.
		.DESCRIPTION
			Retrieves signed URLs for custom fields for a given entity type and Id via the NinjaOne v2 API.
		.FUNCTIONALITY
			Custom Fields
		.EXAMPLE
			PS> Get-NinjaOneEntityCustomFieldsSignedURLs -entityType ORGANIZATION -entityId 1

			Gets custom field signed URLs for the ORGANIZATION entity with Id 1.
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/customfields-signedurls
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnoecfsu')]
	[MetadataAttribute(
		'/v2/custom-fields/entity-type/{entityType}/{entityId}/signed-urls',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The entity type.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[ValidateSet('ORGANIZATION','DOCUMENT','LOCATION','NODE','ATTACHMENT','TECHNICIAN','CREDENTIAL','CHECKLIST','END_USER','CONTACT','KB_DOCUMENT')]
		[String]$entityType,
		# The entity Id.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Int]$entityId
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		if ($entityType) { $Parameters.Remove('entityType') | Out-Null }
		if ($entityId)   { $Parameters.Remove('entityId')   | Out-Null }
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			$Resource = ('v2/custom-fields/entity-type/{0}/{1}/signed-urls' -f $entityType, $entityId)
			$RequestParams = @{ Resource = $Resource; QSCollection = $QSCollection }
			$Result = New-NinjaOneGETRequest @RequestParams
			if ($Result) { return $Result } else { throw ('No custom field signed URLs found for {0} {1}.' -f $entityType, $entityId) }
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

