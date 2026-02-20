function New-NinjaOneCustomField {
	<#
		.SYNOPSIS
			Creates a new custom field.
		.DESCRIPTION
			Creates a new custom field (node attribute) via the NinjaOne v2 API.
		.FUNCTIONALITY
			Custom Fields
		.EXAMPLE
			PS> New-NinjaOneCustomField -CustomField @{ name = 'Department'; type = 'TEXT' }

			Creates a new custom field named 'Department' with type 'TEXT'.
		.OUTPUTS
			A PowerShell object containing the created custom field.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/customfield
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnoodcf')]
	[MetadataAttribute(
		'/v2/custom-fields',
		'post'
	)]
	param(
		# Custom field configuration per API schema
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$CustomField
	)
	process {
		try {
			$Resource = 'v2/custom-fields'
			$RequestParams = @{ Resource = $Resource; Body = $CustomField }
			if ($PSCmdlet.ShouldProcess('Custom Fields', 'Create')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
