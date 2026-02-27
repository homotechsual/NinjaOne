function Set-NinjaOneSoftwareLicense {
	<#
		.SYNOPSIS
			Updates a software license.
		.DESCRIPTION
			Updates an existing software license via the NinjaOne v2 API.
		.FUNCTIONALITY
			Software License
		.EXAMPLE
			PS> Set-NinjaOneSoftwareLicense -LicenseId 1 -License @{ name = 'Microsoft Office 365' }

			Updates the software license with ID 1.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				name = "string"
				description = "string"
				type = "PER_DEVICE"
				purchaseDate = 0
				publisherId = 0
				vendorId = 0
				scope = @{
					global = $false
					organizationIds = @(
						0
					)
					locationIds = @(
						0
					)
				}
				quantity = 0
				currentUsage = 0
				term = @{
					renewalUnit = "MONTH"
					value = 0
					expirationDate = 0
					autoRenewal = $false
					generateActivityAlert = $false
					daysBeforeExpiration = 0
					hasNotifiedExpirationDate = $false
					hasNotifiedUpToRenewal = $false
				}
				notificationChannelInfo = @{
					email = "string"
					sms = "string"
					pushNotification = "string"
				}
				assigmentAutomationSettings = @{
					assignmentType = "NORMALIZED_SOFTWARE"
					type = "string"
				}
				assignedLicenses = @(
					0
				)
				unassignedLicenses = @(
					0
				)
				note = "string"
			}
			PS> Set-NinjaOneSoftwareLicense -LicenseId 1 -License $body
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









