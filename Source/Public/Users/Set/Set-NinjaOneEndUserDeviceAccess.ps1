function Set-NinjaOneEndUserDeviceAccess {
	<#
		.SYNOPSIS
			Updates end user device access.
		.DESCRIPTION
			Updates the set of devices an end user can access using the NinjaOne v2 API.
		.FUNCTIONALITY
			End User Device Access
		.EXAMPLE
			PS> Set-NinjaOneEndUserDeviceAccess -Id 101 -addDeviceIds 10, 11 -removeDeviceIds 12

			Adds devices 10 and 11 and removes device 12 from end user 101 access.
		.OUTPUTS
			The API response indicating success or failure.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/enduserdeviceaccess
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snoeuda')]
	[MetadataAttribute(
		'/v2/user/end-user/{id}/device-access',
		'patch'
	)]
	param(
		# The end user ID.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Int]$id,
		# Device IDs to add to the end user's accessible devices.
		[Parameter(Position = 1, ValueFromPipelineByPropertyName)]
		[Int[]]$addDeviceIds,
		# Device IDs to remove from the end user's accessible devices.
		[Parameter(Position = 2, ValueFromPipelineByPropertyName)]
		[Int[]]$removeDeviceIds
	)
	process {
		try {
			if (-not $PSBoundParameters.ContainsKey('addDeviceIds') -and -not $PSBoundParameters.ContainsKey('removeDeviceIds')) {
				throw 'Specify at least one of addDeviceIds or removeDeviceIds.'
			}

			$Resource = ('v2/user/end-user/{0}/device-access' -f $id)
			$Body = @{}
			if ($PSBoundParameters.ContainsKey('addDeviceIds')) {
				$Body.addDeviceIds = @($addDeviceIds)
			}
			if ($PSBoundParameters.ContainsKey('removeDeviceIds')) {
				$Body.removeDeviceIds = @($removeDeviceIds)
			}
			$RequestParams = @{ Resource = $Resource; Body = $Body }
			if ($PSCmdlet.ShouldProcess(('End User {0}' -f $id), 'Update Device Access')) {
				return (New-NinjaOnePATCHRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
