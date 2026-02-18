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
	Param(
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

