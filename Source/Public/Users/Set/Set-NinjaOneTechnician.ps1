function Set-NinjaOneTechnician {
	<#
		.SYNOPSIS
			Updates a technician.
		.DESCRIPTION
			Updates a technician via the NinjaOne v2 API.
		.FUNCTIONALITY
			Users
		.EXAMPLE
			PS> Set-NinjaOneTechnician -Id 77 -technician @{ phone = '+3100000000' }

			Updates the technician 77.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				firstName = "string"
				lastName = "string"
			}
			PS> Set-NinjaOneTechnician -technician $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			Status code or updated resource per API.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/technician
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snotec')]
	[MetadataAttribute(
		'/v2/user/technician/{id}',
		'patch'
	)]
	param(
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Int]$id,
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$technician
	)
	process {
		try {
			$Resource = ('v2/user/technician/{0}' -f $id)
			$RequestParams = @{ Resource = $Resource; Body = $technician }
			if ($PSCmdlet.ShouldProcess(('Technician {0}' -f $id), 'Update')) {
				$Result = New-NinjaOnePATCHRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}






