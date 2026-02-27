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
				unassignedLicenses = @(
					0
				)
				note = "string"
				purchaseDate = 0
				assignedLicenses = @(
					0
				)
				notificationChannelInfo = @{
					pushNotification = "string"
					sms = "string"
					email = "string"
				}
				publisherId = 0
				type = "PER_DEVICE"
				assigmentAutomationSettings = @{
					type = "string"
					assignmentType = "NORMALIZED_SOFTWARE"
				}
				quantity = 0
				description = "string"
				scope = @{
					locationIds = @(
						0
					)
					global = $false
					organizationIds = @(
						0
					)
				}
				vendorId = 0
				currentUsage = 0
				term = @{
					expirationDate = 0
					value = 0
					generateActivityAlert = $false
					hasNotifiedExpirationDate = $false
					renewalUnit = "MONTH"
					hasNotifiedUpToRenewal = $false
					daysBeforeExpiration = 0
					autoRenewal = $false
				}
				name = "string"
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










