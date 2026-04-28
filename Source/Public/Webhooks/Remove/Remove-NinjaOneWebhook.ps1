function Remove-NinjaOneWebhook {
	<#
		.SYNOPSIS
			Removes webhook configuration for the current application/API client.
		.DESCRIPTION
			Removes webhook configuration for the current application/API client using the NinjaOne v2 API.
			Some instances may expose an id-based delete route; provide -webhookId to target that route.
		.FUNCTIONALITY
			Webhook
		.EXAMPLE
			PS> Remove-NinjaOneWebhook

			Removes the webhook configuration.
		.EXAMPLE
			PS> Remove-NinjaOneWebhook -webhookId '123'

			Removes a specific webhook using the id-based route.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/webhook
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('rnow')]
	[MetadataAttribute(
		'/v2/webhook',
		'delete'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# Optional webhook id for instances that require an id-based delete route.
		[Parameter(ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[String]$webhookId
	)
	process {
		try {
			$Resource = 'v2/webhook'
			if (-not [string]::IsNullOrWhiteSpace($webhookId)) {
				$Resource = ('v2/webhook/{0}' -f $webhookId)
			}
			$RequestParams = @{
				Resource = $Resource
			}
			if ($PSCmdlet.ShouldProcess('Webhook Configuration', 'Delete')) {
				$WebhookConfiguration = New-NinjaOneDELETERequest @RequestParams
				if ($WebhookConfiguration -eq 204) {
					Write-Information 'Webhook configuration deleted successfully.'
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}