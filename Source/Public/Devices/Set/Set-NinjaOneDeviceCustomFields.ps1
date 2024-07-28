function Set-NinjaOneDeviceCustomFields {
	<#
		.SYNOPSIS
			Sets the value of the specified device custom fields.
		.DESCRIPTION
			Sets the value of the specified device custom fields using the NinjaOne v2 API.
		.FUNCTIONALITY
			Device Custom Fields
		.OUTPUTS
			A powershell object containing the response.
		.EXAMPLE
			PS> Set-NinjaOneDeviceCustomFields -deviceId 1 -customFields @{ CustomField1 = 'Value1'; CustomField2 = 'Value2' }

			Set `CustomField1` to `Value1` and `CustomField2` to `Value2` respectively for the device with id 1.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/devicecustomfields
	#>
	[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snodcf', 'unodcf', 'Update-NinjaOneDeviceCustomFields')]
	[MetadataAttribute(
		'/v2/device/{id}/custom-fields',
		'patch'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	Param(
		# The device to set the custom field value(s) for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$deviceId,
		# The custom field(s) body object.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('customFields', 'body')]
		[Object]$deviceCustomFields
	)
	process {
		try {
			Write-Verbose ('Setting custom fields for device {0}.' -f $deviceId)
			$Resource = ('v2/device/{0}/custom-fields' -f $deviceId)
			$RequestParams = @{
				Resource = $Resource
				Body = $deviceCustomFields
			}
			if ($PSCmdlet.ShouldProcess(('Custom Fields for {0}' -f $deviceId), 'Set')) {
				$CustomFieldUpdate = New-NinjaOnePATCHRequest @RequestParams
				if ($CustomFieldUpdate -eq 204) {
					Write-Information ('Custom fields for {0} updated successfully.' -f $deviceId)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}