using namespace System.Management.Automation

function Get-NinjaOneNotificationChannels {
	<#
		.SYNOPSIS
			Gets notification channels from the NinjaOne API.
		.DESCRIPTION
			Retrieves notification channel details from the NinjaOne v2 API.
		.FUNCTIONALITY
			Notification Channels
		.EXAMPLE
			PS> Get-NinjaOneNotificationChannels

			Gets all notification channels.
		.EXAMPLE
			PS> Get-NinjaOneNotificationChannels -enabled

			Gets all enabled notification channels.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/notificationchannels
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnonc', 'Get-NinjaOneNotificationChannel')]
	[MetadataAttribute(
		'/v2/notification-channels',
		'get',
		'/v2/notification-channels/enabled',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# Get all enabled notification channels.
		[Switch]$enabled
	)
	begin {
		# Not used: no parameters to process.
		# $CommandName = $MyInvocation.InvocationName
		# $Parameters = (Get-Command -Name $CommandName).Parameters
		# $QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			Write-Verbose 'Retrieving all enabled notification channels.'
			if ($enabled) {
				$Resource = 'v2/notification-channels/enabled'
			} else {
				$Resource = 'v2/notification-channels'
			}
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			try {
				$NotificationChannelResults = New-NinjaOneGETRequest @RequestParams
				return $NotificationChannelResults
			} catch {
				if (-not $NotificationChannelResults) {
					throw 'No notification channels found.'
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}