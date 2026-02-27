function New-NinjaOneSoftwareLicense {
	<#
		.SYNOPSIS
			Creates a new software license.
		.DESCRIPTION
			Creates a new software license via the NinjaOne v2 API.
		.FUNCTIONALITY
			Software License
		.EXAMPLE
			PS> New-NinjaOneSoftwareLicense -License @{ name = 'Microsoft Office'; description = 'Office 365 subscriptions' }

			Creates a new software license.
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
			PS> New-NinjaOneSoftwareLicense -License $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A PowerShell object containing the created software license.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/softwarelicense
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnoosl')]
	[MetadataAttribute(
		'/v2/software-license',
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
			$Resource = 'v2/software-license'
			$RequestParams = @{ Resource = $Resource; Body = $License }
			if ($PSCmdlet.ShouldProcess('Software License', 'Create')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}









