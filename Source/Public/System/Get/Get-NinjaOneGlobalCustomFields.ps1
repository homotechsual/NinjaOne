function Get-NinjaOneGlobalCustomFields {
	<#
		.SYNOPSIS
			Gets global custom field values from the NinjaOne API.
		.DESCRIPTION
			Retrieves system-wide custom field values, rather than custom field definitions.
		.FUNCTIONALITY
			Global Custom Fields
		.EXAMPLE
			PS> Get-NinjaOneGlobalCustomFields

			Gets global custom field values.
		.OUTPUTS
			A PowerShell object containing the custom field values.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Get/globalcustomfields
	#>
	[CmdletBinding()]
	[OutputType([Object])]
	[Alias('gnogcf')]
	[MetadataAttribute('/v2/system/custom-fields', 'get')]
	param()
	process {
		try {
			Write-Verbose 'Getting global custom field values.'
			return New-NinjaOneGETRequest -Resource 'v2/system/custom-fields'
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
