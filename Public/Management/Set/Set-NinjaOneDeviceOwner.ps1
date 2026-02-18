function Set-NinjaOneDeviceOwner {
	<#
		.SYNOPSIS
			Sets the owner of a device.
		.DESCRIPTION
			Sets the owner of the specified device via the NinjaOne v2 API.
		.FUNCTIONALITY
			Devices
		.EXAMPLE
			PS> Set-NinjaOneDeviceOwner -id 1234 -ownerUid 'user-uuid-1'

			Sets the owner of device 1234 to the specified user.
		.OUTPUTS
			Status code or updated resource per API.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/deviceowner
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snodo')]
	[MetadataAttribute(
		'/v2/device/{id}/owner/{ownerUid}',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# Device identifier
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Int]$id,
		# Owner UID
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[String]$ownerUid
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		if ($id) { $Parameters.Remove('id') | Out-Null }
		if ($ownerUid) { $Parameters.Remove('ownerUid') | Out-Null }
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			$Resource = ('v2/device/{0}/owner/{1}' -f $id, $ownerUid)
			$RequestParams = @{ Resource = $Resource; QSCollection = $QSCollection }
			if ($PSCmdlet.ShouldProcess(('Device {0}' -f $id), ('Set owner {0}' -f $ownerUid))) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

