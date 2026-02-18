function Remove-NinjaOneDeviceOwner {
	<#
		.SYNOPSIS
			Removes the owner of a device.
		.DESCRIPTION
			Removes the owner of the specified device via the NinjaOne v2 API.
		.FUNCTIONALITY
			Devices
		.EXAMPLE
			PS> Remove-NinjaOneDeviceOwner -id 1234 -Confirm:$false

			Removes the owner of device 1234.
		.OUTPUTS
			Status code (204) on success.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/deviceowner
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('rnodo')]
	[MetadataAttribute(
		'/v2/device/{id}/owner',
		'delete'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# Device identifier
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Int]$id
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		if ($id) { $Parameters.Remove('id') | Out-Null }
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			$Resource = ('v2/device/{0}/owner' -f $id)
			$RequestParams = @{ Resource = $Resource; QSCollection = $QSCollection }
			if ($PSCmdlet.ShouldProcess(('Device {0}' -f $id), 'Remove owner')) {
				$Response = New-NinjaOneDELETERequest @RequestParams
				if ($Response -eq 204) { Write-Information ('Device {0} owner removed.' -f $id) }
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

