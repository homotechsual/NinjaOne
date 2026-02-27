function New-NinjaOneTechnician {
	<#
		.SYNOPSIS
			Creates a new technician.
		.DESCRIPTION
			Creates a new technician via the NinjaOne v2 API.
		.FUNCTIONALITY
			Users
		.EXAMPLE
			PS> New-NinjaOneTechnician -technician @{ firstName = 'John'; lastName = 'Smith'; email = 'john@example.com' }

			Creates a new technician.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				phone = "string"
				lastName = "string"
				firstName = "string"
				email = "string"
			}
			PS> New-NinjaOneTechnician -technician $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A PowerShell object containing the created technician.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/technician
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnotec')]
	[MetadataAttribute(
		'/v2/user/technicians',
		'post'
	)]
	param(
		# Technician payload per API schema.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$technician
	)
	process {
		try {
			$Resource = 'v2/user/technicians'
			$RequestParams = @{ Resource = $Resource; Body = $technician }
			if ($PSCmdlet.ShouldProcess('Technician', 'Create')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}






