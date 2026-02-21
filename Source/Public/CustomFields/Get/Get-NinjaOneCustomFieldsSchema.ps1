function Get-NinjaOneCustomFieldsSchema {
	<#
		.SYNOPSIS
			Gets custom fields with pagination.
		.DESCRIPTION
			Retrieves custom fields (node attributes) with pagination support from the NinjaOne v2 API.
		.FUNCTIONALITY
			Custom Fields
		.EXAMPLE
			PS> Get-NinjaOneCustomFieldsSchema

			Gets custom fields with default pagination.
		.OUTPUTS
			A PowerShell object containing the custom fields.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/customfields-schema
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnoodcfs')]
	[MetadataAttribute(
		'/v2/custom-fields',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# Pagination cursor
		[Parameter(Position = 0, ValueFromPipelineByPropertyName)]
		[String]$CursorName,
		# Page size
		[Parameter(Position = 1, ValueFromPipelineByPropertyName)]
		[ValidateRange(5, 500)]
		[Int]$PageSize
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			$Resource = 'v2/custom-fields'
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$CustomFieldsSchemaResults = New-NinjaOneGETRequest @RequestParams
			if ($CustomFieldsSchemaResults) {
				return $CustomFieldsSchemaResults
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
