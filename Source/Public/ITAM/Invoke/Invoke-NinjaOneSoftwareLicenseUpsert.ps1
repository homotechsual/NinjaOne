function Invoke-NinjaOneSoftwareLicenseUpsert {
	<#
		.SYNOPSIS
			Creates or updates a software license.
		.DESCRIPTION
			Creates or updates a software license via the NinjaOne v2 API.
		.FUNCTIONALITY
			Software License
		.EXAMPLE
			PS> Invoke-NinjaOneSoftwareLicenseUpsert -License @{ name = 'Microsoft Office'; description = 'Office 365' }

			Creates or updates a software license.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				name = "string"
				description = "string"
				type = "PER_DEVICE"
				date = 0
				publisherName = "string"
				vendorName = "string"
				scope = @{
					global = $false
					organizationNames = @(
						"string"
					)
					locationNames = @(
						"string"
					)
				}
				quantity = 0
				currentUsage = 0
				currentLicensees = @(
					"string"
				)
				licenseesToAssign = @(
					"string"
				)
				licenseesToRemove = @(
					"string"
				)
				note = "string"
			}
			PS> Invoke-NinjaOneSoftwareLicenseUpsert -License $body
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
		[Object]$License
	)
	process {
		try {
			$Resource = 'v2/software-license/upsert'
			$RequestParams = @{ Resource = $Resource; Body = $License }
			if ($PSCmdlet.ShouldProcess('Software License', 'Upsert')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}









