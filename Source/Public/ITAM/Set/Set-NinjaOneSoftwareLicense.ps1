function Set-NinjaOneSoftwareLicense {
	<#
		.SYNOPSIS
			Updates a software license.
		.DESCRIPTION
			Updates an existing software license via the NinjaOne v2 API.
		.FUNCTIONALITY
			Software Licenses
		.EXAMPLE
			PS> Set-NinjaOneSoftwareLicense -LicenseId 1 -License @{ name = 'Microsoft Office 365' }

			Updates the software license with ID 1.
		.OUTPUTS
			A PowerShell object containing the updated software license.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/softwarelicense
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snoosl')]
	[MetadataAttribute(
		'/v2/software-license/{licenseId}',
		'put'
	)]
	param(
		# The ID of the software license to update
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('id', 'licenseid')]
		[Int]$LicenseId,
		# Software license update payload per API schema
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$License
	)
	process {
		try {
			$Resource = ('v2/software-license/{0}' -f $LicenseId)
			$RequestParams = @{ Resource = $Resource; Body = $License }
			if ($PSCmdlet.ShouldProcess('Software License', ('Update {0}' -f $LicenseId))) {
				$Result = New-NinjaOnePUTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
