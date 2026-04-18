function Invoke-NinjaOneCustomFieldsBulk {
	<#
		.SYNOPSIS
			Performs bulk operations on custom fields.
		.DESCRIPTION
			Performs bulk create, update, or delete operations on custom fields via the NinjaOne v2 API.
		.FUNCTIONALITY
			Custom Fields Bulk
		.EXAMPLE
			PS> Invoke-NinjaOneCustomFieldsBulk -operation 'create' -customFields @( @{ name = 'Field1' }, @{ name = 'Field2' } )

			Creates multiple custom fields in a single request.
		.OUTPUTS
			A PowerShell object containing the result of the bulk operation.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/customfields-bulk
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
	[OutputType([Object])]
	[Alias('inoodcfb')]
	[MetadataAttribute(
		'/v2/custom-fields/bulk',
		'post',
		'/v2/custom-fields/bulk',
		'put',
		'/v2/custom-fields/bulk',
		'delete'
	)]
	param(
		# Operation type: 'create', 'update', or 'delete'
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[ValidateSet('create', 'update', 'delete')]
		[String]$operation,
		# Custom fields payload per API schema
		[Parameter(ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$customFields,
		# Field names for delete operation
		[Parameter(ValueFromPipelineByPropertyName)]
		[String[]]$fieldNames
	)
	process {
		try {
			$Resource = 'v2/custom-fields/bulk'
			
			switch ($operation) {
				'create' {
					$Body = $customFields
					$Method = 'post'
				}
				'update' {
					$Body = $customFields
					$Method = 'put'
				}
				'delete' {
					$Method = 'delete'
					#Return custom object for query string parameters
					$Query = @{'fieldNames' = ($fieldNames -join ',')}
				}
			}
			
			if ($PSCmdlet.ShouldProcess('Custom Fields', ('Bulk {0}' -f $operation))) {
				if ($Method -eq 'delete') {
					$Result = New-NinjaOneDELETERequest -Resource $Resource -QSCollection $Query
				} elseif ($Method -eq 'post') {
					$Result = New-NinjaOnePOSTRequest -Resource $Resource -Body $Body
				} elseif ($Method -eq 'put') {
					$Result = New-NinjaOnePUTRequest -Resource $Resource -Body $Body
				}
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
