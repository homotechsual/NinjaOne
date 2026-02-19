function Remove-NinjaOneTab {
	<#
		.SYNOPSIS
			Removes a custom tab.
		.DESCRIPTION
			Deletes a custom tab via the NinjaOne v2 API.
		.FUNCTIONALITY
			Tabs
		.EXAMPLE
			PS> Remove-NinjaOneTab -tabId 5 -Confirm:$false

			Deletes tab 5.
		.OUTPUTS
			Status code (204) on success.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/tab
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('rnotab')]
	[MetadataAttribute(
		'/v2/tab/{tabId}',
		'delete'
	)]
	param(
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Int]$tabId
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		if ($tabId) { $Parameters.Remove('tabId') | Out-Null }
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			$Resource = ('v2/tab/{0}' -f $tabId)
			$RequestParams = @{ Resource = $Resource; QSCollection = $QSCollection }
			if ($PSCmdlet.ShouldProcess(('Tab {0}' -f $tabId), 'Delete')) {
				$Response = New-NinjaOneDELETERequest @RequestParams
				if ($Response -eq 204) { Write-Information ('Tab {0} deleted successfully.' -f $tabId) }
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

