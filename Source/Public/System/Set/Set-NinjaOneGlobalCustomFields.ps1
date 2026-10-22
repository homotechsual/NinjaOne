function Set-NinjaOneGlobalCustomFields {
	<#
		.SYNOPSIS
			Updates global custom field values.
		.DESCRIPTION
			Updates system-wide custom field values using the NinjaOne v2 API.
		.FUNCTIONALITY
			Global Custom Fields
		.EXAMPLE
			PS> Set-NinjaOneGlobalCustomFields -globalCustomFields @{ region = 'Europe' }

			Updates the global region custom field value.
		.OUTPUTS
			An information message when the update succeeds.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/globalcustomfields
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('snogcf', 'Update-NinjaOneGlobalCustomFields')]
	[MetadataAttribute('/v2/system/custom-fields', 'patch')]
	param(
		# The global custom field values to update.
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('customFields', 'body')]
		[Object]$globalCustomFields
	)
	process {
		try {
			Write-Verbose 'Setting global custom field values.'
			$RequestParams = @{
				Resource = 'v2/system/custom-fields'
				Body = $globalCustomFields
			}
			if ($PSCmdlet.ShouldProcess('Global custom fields', 'Update')) {
				$GlobalCustomFieldsUpdate = New-NinjaOnePATCHRequest @RequestParams
				if ($GlobalCustomFieldsUpdate -eq 204) {
					Write-Information 'Global custom fields updated successfully.'
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
