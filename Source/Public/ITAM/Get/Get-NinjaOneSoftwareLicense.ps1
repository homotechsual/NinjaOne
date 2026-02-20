function Get-NinjaOneSoftwareLicense {
	<#
		.SYNOPSIS
			Gets a software license by ID.
		.DESCRIPTION
			Retrieves a specific software license by its ID from the NinjaOne v2 API.
		.FUNCTIONALITY
			Software Licenses
		.EXAMPLE
			PS> Get-NinjaOneSoftwareLicense -LicenseId 1

			Gets the software license with ID 1.
		.OUTPUTS
			A PowerShell object containing the software license.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/softwarelicense
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnoosl')]
	[MetadataAttribute(
		'/v2/software-license/{licenseId}',
		'get'
	)]
	param(
		# The ID of the software license
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('id', 'licenseid')]
		[Int]$LicenseId
	)
	process {
		try {
			$Resource = ('v2/software-license/{0}' -f $LicenseId)
			$RequestParams = @{
				Resource = $Resource
			}
			$SoftwareLicenseResults = New-NinjaOneGETRequest @RequestParams
			if ($SoftwareLicenseResults) {
				return $SoftwareLicenseResults
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}
