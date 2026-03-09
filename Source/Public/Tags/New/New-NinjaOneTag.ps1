function New-NinjaOneTag {
	<#
		.SYNOPSIS
			Creates a new tag.
		.DESCRIPTION
			Creates a new tag via the NinjaOne v2 API.
		.FUNCTIONALITY
			Asset Tag
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				description = "string"
				name = "string"
			}
			PS> New-NinjaOneTag -tag $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A PowerShell object containing the created tag.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/tag
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnotag', 'nnotagg')]
	[MetadataAttribute(
		'/v2/tag',
		'post'
	)]
	param(
		# Tag payload per API schema
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$tag
	)
	process {
		try {
			$Resource = 'v2/tag'
			$RequestParams = @{ Resource = $Resource; Body = $tag }
			if ($PSCmdlet.ShouldProcess('Tag', 'Create')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
















