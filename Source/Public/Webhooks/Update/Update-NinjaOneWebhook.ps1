function Update-NinjaOneWebhook {
	<#
		.SYNOPSIS
			Update webhook configuration for the current application/API client.
		.DESCRIPTION
			Updates webhook configuration for the current application/API client using the NinjaOne v2 API.
		.FUNCTIONALITY
			Webhook
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				activities = @{
					additionalProp1 = @(
						"string"
					)
				}
				url = "string"
				headers = @(
					@{
						value = "string"
						name = "string"
					}
				)
				organizationIds = @(
					0
				)
				expand = @(
					"string"
				)
			}
			PS> Update-NinjaOneWebhook -webhookConfiguration $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A powershell object containing the response.
	
	.EXAMPLE
		PS> Update-NinjaOneWebhook

		Updates the resource.

	#>
	[CmdletBinding( SupportsShouldProcess, ConfirmImpact = 'Medium' )]
	[OutputType([Object])]
	[Alias('unow', 'snow', 'Set-NinjaOneWebhook')]
	[MetadataAttribute(
		'/v2/webhook',
		'put'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The webhook configuration object.
		[Parameter( Mandatory )]
		[Alias('body')]
		[Object]$webhookConfiguration
	)
	process {
		try {
			$Resource = 'v2/webhook'
			$RequestParams = @{
				Resource = $Resource
				Body = $webhookConfiguration
			}
			if ($PSCmdlet.ShouldProcess('Webhook Configuration', 'Update')) {
				$WebhookUpdate = New-NinjaOnePUTRequest @RequestParams
				if ($WebhookUpdate -eq 204) {
					Write-Information 'Webhook configuration updated successfully.'
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}










