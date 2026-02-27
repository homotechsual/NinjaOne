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
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				scope = @{
					locationIds = @(
						0
					)
					global = $false
					organizationIds = @(
						0
					)
				}
				purchaseDate = 0
				term = @{
					renewalUnit = "MONTH"
					expirationDate = 0
					daysBeforeExpiration = 0
					generateActivityAlert = $false
					hasNotifiedExpirationDate = $false
					hasNotifiedUpToRenewal = $false
					value = 0
					autoRenewal = $false
				}
				vendorId = 0
				description = "string"
				type = "PER_DEVICE"
				publisherId = 0
				notificationChannelInfo = @{
					sms = "string"
					pushNotification = "string"
					email = "string"
				}
				name = "string"
				note = "string"
				assigmentAutomationSettings = @{
					type = "string"
					assignmentType = "NORMALIZED_SOFTWARE"
				}
				unassignedLicenses = @(
					0
				)
				assignedLicenses = @(
					0
				)
				quantity = 0
				currentUsage = 0
			}
			PS> Set-NinjaOneSoftwareLicense -LicenseId <value> -License $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
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
		[Alias('id')]
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





