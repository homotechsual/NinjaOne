
function Get-NinjaOneDeviceDisks {
	<#
		.SYNOPSIS
			Gets device disks from the NinjaOne API.
		.DESCRIPTION
			Retrieves device disks from the NinjaOne v2 API.
		.FUNCTIONALITY
			Device Disk drives
		.EXAMPLE
			PS> Get-NinjaOneDeviceDisks -deviceId 1

			Gets the disks for the device with id 1.
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicedisks
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnodd', 'gnoddd', 'Get-NinjaOneDeviceDiskDrives')]
	[MetadataAttribute(
		'/v2/device/{id}/disks',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# Device id to get disk information for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$deviceId
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
			Write-Verbose ('Getting disks for device {0}.' -f $Device.SystemName)
			$Resource = ('v2/device/{0}/disks' -f $deviceId)
			$RequestParams = @{
				Resource = $Resource
				QSCollection = $QSCollection
			}
			$DeviceDiskResults = New-NinjaOneGETRequest @RequestParams
			return $DeviceDiskResults
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
