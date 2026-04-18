function Remove-NinjaOneSoftwareLicense {
	<#
		.SYNOPSIS
			Deletes a software license.
		.DESCRIPTION
			Deletes a software license via the NinjaOne v2 API.
		.FUNCTIONALITY
			Software License
		.EXAMPLE
			PS> Remove-NinjaOneSoftwareLicense -licenseId 1

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
		[Alias('id')]
		[Int]$licenseId
	)
	process {
		try {
			$Resource = ('v2/software-license/{0}' -f $licenseId)
			if ($PSCmdlet.ShouldProcess('Software License', ('Delete {0}' -f $licenseId))) {
				$Result = New-NinjaOneDELETERequest -Resource $Resource
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
