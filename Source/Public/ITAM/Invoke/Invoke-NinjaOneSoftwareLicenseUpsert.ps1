function Invoke-NinjaOneSoftwareLicenseUpsert {
	<#
		.SYNOPSIS
			Creates or updates a software license.
		.DESCRIPTION
			Creates or updates a software license via the NinjaOne v2 API.
		.FUNCTIONALITY
			Software License
		.EXAMPLE
			PS> Invoke-NinjaOneSoftwareLicenseUpsert -license @{ name = 'Microsoft Office'; description = 'Office 365' }

			Creates or updates a software license.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				currentLicensees = @(
					"string"
				)
				note = "string"
				quantity = 0
				type = "PER_DEVICE"
				licenseesToAssign = @(
					"string"
				)
				vendorName = "string"
				date = 0
				description = "string"
				scope = @{
					locationNames = @(
						"string"
					)
					global = $false
					organizationNames = @(
						"string"
					)
				}
				currentUsage = 0
				licenseesToRemove = @(
					"string"
				)
				name = "string"
				publisherName = "string"
			}
			PS> Invoke-NinjaOneSoftwareLicenseUpsert -license $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A PowerShell object containing the created or updated software license.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Invoke/softwarelicense-upsert
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('inoosl-upsert', 'inoosl')]
	[MetadataAttribute(
		'/v2/software-license/upsert',
		'post'
	)]
	param(
		# Software license configuration per API schema
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$license
	)
	process {
		try {
			$Resource = 'v2/software-license/upsert'
			$RequestParams = @{ Resource = $Resource; Body = $license }
			if ($PSCmdlet.ShouldProcess('Software License', 'Upsert')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}










