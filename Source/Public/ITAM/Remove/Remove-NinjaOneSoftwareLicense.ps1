function Remove-NinjaOneSoftwareLicense {
	<#
		.SYNOPSIS
			Deletes a software license.
		.DESCRIPTION
			Deletes a software license via the NinjaOne v2 API.
		.FUNCTIONALITY
			Software Licenses
		.EXAMPLE
			PS> Remove-NinjaOneSoftwareLicense -LicenseId 1

			Deletes the software license with ID 1.
		.OUTPUTS
			The API response indicating success or failure.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/softwarelicense
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
	[OutputType([Object])]
	[Alias('rnoosl')]
	[MetadataAttribute(
		'/v2/software-license/{licenseId}',
		'delete'
	)]
	param(
		# The ID of the software license to delete
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('id', 'licenseid')]
		[Int]$LicenseId
	)
	process {
		try {
			$Resource = ('v2/software-license/{0}' -f $LicenseId)
			if ($PSCmdlet.ShouldProcess('Software License', ('Delete {0}' -f $LicenseId))) {
				$Result = New-NinjaOneDELETERequest -Resource $Resource
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
