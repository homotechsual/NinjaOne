function Set-NinjaOneWindowsServiceConfiguration {
	<#
		.SYNOPSIS
			Sets the configuration of the given Windows Service for the given device.
		.DESCRIPTION
			Sets the configuration of the Windows Service for a single device using the NinjaOne v2 API.
		.FUNCTIONALITY
			Windows Service Configuration
		.OUTPUTS
			A powershell object containing the response.
		.EXAMPLE
			Set-NinjaOneWindowsServiceConfiguration -deviceId "12345" -serviceId "NinjaRMMAgent" -Configuration @{ startType = "AUTO_START"; userName = "LocalSystem" }
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/windowsserviceconfiguration
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snowsc', 'unowsc', 'Update-NinjaOneWindowsServiceConfiguration')]
	[MetadataAttribute(
		'/v2/device/{id}/windows-service/{serviceId}/configure',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The device to change servce configuration for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$deviceId,
		# The service to alter configuration for.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Int]$serviceId,
		# The configuration to set.
		[Parameter(Mandatory, Position = 2, ValueFromPipelineByPropertyName)]
		[Object]$configuration
	)
	process {
		try {
			$Resource = ('v2/device/{0}/windows-service/{1}/configure' -f $deviceId, $serviceId)
			$RequestParams = @{
				Resource = $Resource
				Body = $configuration
			}
			if ($PSCmdlet.ShouldProcess(('Service {0} configuration' -f $serviceId), 'Set')) {
				$ServiceConfiguration = New-NinjaOnePOSTRequest @RequestParams
				if ($ServiceConfiguration -eq 204) {
					Write-Information ('Service {0} configuration updated successfully.' -f $serviceId)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
