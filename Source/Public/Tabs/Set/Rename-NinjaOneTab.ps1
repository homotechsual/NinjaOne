function Rename-NinjaOneTab {
	<#
		.SYNOPSIS
			Renames a custom tab.
		.DESCRIPTION
			Renames a custom tab via the NinjaOne v2 API.
		.FUNCTIONALITY
			Tabs
		.EXAMPLE
			PS> Rename-NinjaOneTab -rename @{ tabId = 5; name = 'New Name' }

			Renames tab 5.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				description = "string"
				tabId = 0
				name = "string"
			}
			PS> Rename-NinjaOneTab -rename $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/tab-rename
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[OutputType([Object])]
	[Alias('rnotab')]
	[MetadataAttribute(
		'/v2/tab/rename',
		'patch'
	)]
	param(
		# Payload e.g. @{ tabId = 5; name = 'New Name' }
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$rename
	)
	process {
		try {
			if($PSCmdlet.ShouldProcess('Tab','Rename')){ return (New-NinjaOnePATCHRequest -Resource 'v2/tab/rename' -Body $rename) }
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}










