function Get-NinjaOneDeviceSoftwareInventory {
	<#
        .SYNOPSIS
            Wrapper command using `Get-NinjaOneSoftwareProducts` to get installed software products for a device.
		.DESCRIPTION
			Gets installed software products for a device using the NinjaOne v2 API.
        .FUNCTIONALITY
            Device Software Inventory
        .EXAMPLE
            Get-NinjaOneDeviceAlerts -deviceId 1

            Gets alerts for the device with id 1.
        .OUTPUTS
            A powershell object containing the response.
        .LINK
            https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/devicealerts
    #>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnodsi', 'gnods', 'Get-NinjaOneDeviceSoftware')]
	[MetadataAttribute(
		'/v2/device/{id}/software',
		'get'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# Filter by device id.
		[Parameter(Mandatory, ParameterSetName = 'Single Device', Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$deviceId
	)
	begin {	}
	process {
		try {
			$DeviceSoftwareInventory = Get-NinjaOneSoftwareProducts -deviceId $deviceId
			if ($DeviceSoftwareInventory) {
				return $DeviceSoftwareInventory
			} else {
				New-NinjaOneError -Message ('No software products found for the device with the id {0}.' -f $deviceId)
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}