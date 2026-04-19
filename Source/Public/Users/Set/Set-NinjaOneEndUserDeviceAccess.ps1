function Set-NinjaOneEndUserDeviceAccess {
	<#
		.SYNOPSIS
			Updates end user device access.
		.DESCRIPTION
			Updates device access settings for an end user using the NinjaOne v2 API.
		.FUNCTIONALITY
			End User Device Access
		.EXAMPLE
			PS> Set-NinjaOneEndUserDeviceAccess -id 101 -deviceAccess @{ canRemote = $true }

			Updates device access settings for end user 101.
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
		# The device access payload per API schema.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$deviceAccess
	)
	process {
		try {
			$Resource = ('v2/user/end-user/{0}/device-access' -f $id)
			$RequestParams = @{ Resource = $Resource; Body = $deviceAccess }
			if ($PSCmdlet.ShouldProcess(('End User {0}' -f $id), 'Update Device Access')) {
				return (New-NinjaOnePATCHRequest @RequestParams)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
