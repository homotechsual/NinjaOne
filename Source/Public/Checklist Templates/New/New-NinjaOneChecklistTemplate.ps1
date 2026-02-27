function New-NinjaOneChecklistTemplate {
	<#
		.SYNOPSIS
			Creates a checklist template.
		.DESCRIPTION
			Creates a new checklist template via the NinjaOne v2 API.
		.FUNCTIONALITY
			Checklist Templates
		.EXAMPLE
			PS> New-NinjaOneChecklistTemplate -template @{ name='Onboarding'; tasks=@( @{ name = 'Step1' } ) }

			Creates a checklist template.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @(
				@{
					description = @{
						text = "string"
						html = "string"
					}
					required = $false
					tasks = @(
						@{
							position = 0
							description = @{
							}
							name = "string"
						}
					)
					name = "string"
				}
			)
			PS> New-NinjaOneChecklistTemplate -template $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A PowerShell object containing the created template.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/checklisttemplate
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[OutputType([Object])]
	[Alias('nnoct')]
	[MetadataAttribute(
		'/v2/checklist/templates',
		'post'
	)]
	param(
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$template
	)
	process { try { if($PSCmdlet.ShouldProcess('Checklist Template','Create')){ return (New-NinjaOnePOSTRequest -Resource 'v2/checklist/templates' -Body $template) } } catch { New-NinjaOneError -ErrorRecord $_ } }
}











