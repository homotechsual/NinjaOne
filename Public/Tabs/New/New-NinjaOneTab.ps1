function New-NinjaOneTab {
	<#
		.SYNOPSIS
			Creates a new custom tab.
		.DESCRIPTION
			Creates a new custom tab via the NinjaOne v2 API.
		.FUNCTIONALITY
			Tabs
		.EXAMPLE
			PS> New-NinjaOneTab -tab @{ name='My Tab'; scope='ORGANIZATION' }

			Creates a new tab.
		.OUTPUTS
			A PowerShell object containing the created tab.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/tab
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnotab')]
	[MetadataAttribute(
		'/v2/tab',
		'post'
	)]
	param(
		# Payload to create tab per API schema
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$tab
	)
	process {
		try {
			if ($PSCmdlet.ShouldProcess('Tab', 'Create')) { return (New-NinjaOnePOSTRequest -Resource 'v2/tab' -Body $tab) }
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

