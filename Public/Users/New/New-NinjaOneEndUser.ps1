function New-NinjaOneEndUser {
	<#
		.SYNOPSIS
			Creates a new end user.
		.DESCRIPTION
			Creates a new end user via the NinjaOne v2 API.
		.FUNCTIONALITY
			Users
		.EXAMPLE
			PS> New-NinjaOneEndUser -endUser @{ firstName = 'Jane'; lastName = 'Doe'; email = 'jane@example.com' }

			Creates a new end user.
		.OUTPUTS
			A PowerShell object containing the created end user.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/enduser
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnoeu')]
	[MetadataAttribute(
		'/v2/user/end-users',
		'post'
	)]
	Param(
		# End user payload per API schema.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$endUser
	)
	process {
		try {
			$Resource = 'v2/user/end-users'
			$RequestParams = @{ Resource = $Resource; Body = $endUser }
			if ($PSCmdlet.ShouldProcess('EndUser', 'Create')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}

