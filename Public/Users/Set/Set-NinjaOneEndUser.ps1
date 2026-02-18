function Set-NinjaOneEndUser {
	<#
		.SYNOPSIS
			Updates an end user.
		.DESCRIPTION
			Updates an end user via the NinjaOne v2 API.
		.FUNCTIONALITY
			Users
		.EXAMPLE
			PS> Set-NinjaOneEndUser -Id 101 -endUser @{ phone = '+3100000000' }

			Updates the end user 101.
		.OUTPUTS
			Status code or updated resource per API.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/enduser
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snoeu')]
	[MetadataAttribute(
		'/v2/user/end-user/{id}',
		'patch'
	)]
	Param(
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Int]$id,
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$endUser
	)
	process {
		try {
			$Resource = ('v2/user/end-user/{0}' -f $id)
			$RequestParams = @{ Resource = $Resource; Body = $endUser }
			if ($PSCmdlet.ShouldProcess(('End user {0}' -f $id), 'Update')) {
				$Result = New-NinjaOnePATCHRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

