function Set-NinjaOneTab {
	<#
		.SYNOPSIS
			Updates a custom tab.
		.DESCRIPTION
			Updates a custom tab via the NinjaOne v2 API.
		.FUNCTIONALITY
			Tabs
		.EXAMPLE
			PS> Set-NinjaOneTab -tabId 5 -tab @{ name = 'New Name' }

			Updates tab 5.
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
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Int]$tabId,
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
