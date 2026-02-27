function Set-NinjaOneChecklistTemplates {
	<#
		.SYNOPSIS
			Updates checklist templates.
		.DESCRIPTION
			Updates checklist templates via the NinjaOne v2 API.
		.FUNCTIONALITY
			Checklist Templates
		.EXAMPLE
			PS> Set-NinjaOneChecklistTemplates -templates @{ templates = @(@{ id=1; name='New' }) }

			Updates the specified templates.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @(
				@{
					id = 0
					name = "string"
					description = @{
						text = "string"
						html = "string"
					}
					tasks = @(
						@{
							position = 0
							name = "string"
							description = @{
							}
						}
					)
					required = $false
				}
			)
			PS> Set-NinjaOneChecklistTemplates -templates $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/checklisttemplates
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[OutputType([Object])]
	[Alias('snocltm')]
	[MetadataAttribute(
		'/v2/checklist/templates',
		'put'
	)]
	param(
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$templates
	)
	process { try { if($PSCmdlet.ShouldProcess('Checklist Templates','Update')){ return (New-NinjaOnePUTRequest -Resource 'v2/checklist/templates' -Body $templates) } } catch { New-NinjaOneError -ErrorRecord $_ } }
}









