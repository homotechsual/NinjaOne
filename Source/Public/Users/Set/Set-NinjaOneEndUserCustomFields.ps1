function Set-NinjaOneEndUserCustomFields {
	<#
		.SYNOPSIS
			Updates custom fields for an end user.
		.DESCRIPTION
			Updates end user custom fields via the NinjaOne v2 API.
		.FUNCTIONALITY
			End User Custom Fields
		.EXAMPLE
			PS> Set-NinjaOneEndUserCustomFields -Id 101 -customFields @{ field1='value' }

			Updates custom fields for end user 101.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				additionalProp1 = @{
				}
			}
			PS> Set-NinjaOneEndUserCustomFields -id 1 -customFields $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/enduser-customfields
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[OutputType([Object])]
	[Alias('snoeucf')]
	[MetadataAttribute(
		'/v2/user/end-user/{id}/custom-fields',
		'patch'
	)]
	param(
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Int]$id,
		[Parameter(Mandatory, Position=1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$customFields
	)
	process {
		try {
			$res='v2/user/end-user/{0}/custom-fields' -f $id
			if($PSCmdlet.ShouldProcess(('End user {0}' -f $id),'Update Custom Fields')){ return (New-NinjaOnePATCHRequest -Resource $res -Body $customFields) }
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}










