
function Get-NinjaOneDeviceOSPatches {
	<#
		.SYNOPSIS
			Gets device OS patches from the NinjaOne API.
		.DESCRIPTION
			Retrieves device OS patches from the NinjaOne v2 API. If you want patch information for multiple devices please check out the related 'queries' commandlet `Get-NinjaOneOSPatches`.
		.FUNCTIONALITY
			Device OS Patches
		.EXAMPLE
			PS> Get-NinjaOneDeviceOSPatches -deviceId 1

			Gets OS patch information for the device with id 1.
		.EXAMPLE
			PS> Get-NinjaOneDeviceOSPatches -deviceId 1 -status 'APPROVED' -type 'SECURITY_UPDATES' -severity 'CRITICAL'

			Gets OS patch information for the device with id 1 where the patch is an approved security update with critical severity.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/deviceospatches
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnodosp')]
	[MetadataAttribute(
		'/v2/device/{id}/os-patches',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# Device id to get OS patch information for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$deviceId,
		# Filter returned patches by patch status.
		[Parameter(Position = 1)]
		[ValidateSet('MANUAL', 'APPROVED', 'FAILED', 'REJECTED')]
		[String[]]$status,
		# Filter returned patches by type.
		[Parameter(Position = 2)]
		[ValidateSet('UPDATE_ROLLUPS', 'SECURITY_UPDATES', 'DEFINITION_UPDATES', 'CRITICAL_UPDATES', 'REGULAR_UPDATES', 'FEATURE_PACKS', 'DRIVER_UPDATES')]
		[String[]]$type,
		# Filter returned patches by severity.
		[Parameter(Position = 3)]
		[ValidateSet('OPTIONAL', 'MODERATE', 'IMPORTANT', 'CRITICAL')]
		[String[]]$severity
	)
	begin {
		$CommandName = $MyInvocation.InvocationName
		$Parameters = (Get-Command -Name $CommandName).Parameters
		# Workaround to prevent the query string processor from adding an 'deviceid=' parameter by removing it from the set parameters.
		$Parameters.Remove('deviceId') | Out-Null
		$QSCollection = New-NinjaOneQuery -CommandName $CommandName -Parameters $Parameters
	}
	process {
		try {
			Write-Verbose ('Getting OS patches for device {0}.' -f $Device.SystemName)
			$Resource = ('v2/device/{0}/os-patches' -f $deviceId)
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$DeviceOSPatchResults = New-NinjaOneGETRequest @RequestParams
			return $DeviceOSPatchResults
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}