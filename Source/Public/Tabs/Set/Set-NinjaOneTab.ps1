function Set-NinjaOneTab {
	<#
		.SYNOPSIS
			Updates a custom tab.
		.DESCRIPTION
			Updates a custom tab via the NinjaOne v2 API.
		.FUNCTIONALITY
			Tab
		.EXAMPLE
			PS> Set-NinjaOneTab -tabId 5 -tab @{ name = 'New Name' }

			Updates tab 5.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				position = 0
				items = @(
					@{
						uiElementUid = "00000000-0000-0000-0000-000000000000"
						uiElementValue = "string"
						uiElementCreateTime = 0
						itemType = "ATTRIBUTE"
						uiElementType = "TITLE"
						id = 0
						name = "string"
						uiElementUpdateTime = 0
					}
				)
				roleId = 0
			}
			PS> Set-NinjaOneTab -tabId 1 -tab $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/tab
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[OutputType([Object])]
	[Alias('snotab')]
	[MetadataAttribute(
		'/v2/tab/{tabId}',
		'patch'
	)]
	param(
		# The tab Id to update.
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Int]$tabId,
		# The tab update object.
		[Parameter(Mandatory, Position=1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$tab
	)
	process {
		try {
			$res='v2/tab/{0}' -f $tabId
			if($PSCmdlet.ShouldProcess(('Tab {0}' -f $tabId),'Update')){ return (New-NinjaOnePATCHRequest -Resource $res -Body $tab) }
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}










