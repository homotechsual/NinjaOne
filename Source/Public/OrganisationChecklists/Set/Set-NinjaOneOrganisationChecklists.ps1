function Set-NinjaOneOrganisationChecklists {
	<#
		.SYNOPSIS
			Updates organisation checklists.
		.DESCRIPTION
			Updates organisation checklists via the NinjaOne v2 API.
		.FUNCTIONALITY
			Organisation Checklists
		.EXAMPLE
			PS> Set-NinjaOneOrganisationChecklists -checklists @{ ... }

			Updates organisation checklists.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @(
				@{
					required = $false
					tasks = @(
						@{
							completed = $false
							assignedToUserId = 0
							position = 0
							description = @{
								text = "string"
								html = "string"
							}
							id = 0
							name = "string"
							dueDate = 0
						}
					)
					description = @{
					}
					checklistId = 0
					assignedToUserId = 0
					name = "string"
					dueDate = 0
				}
			)
			PS> Set-NinjaOneOrganisationChecklists -checklists $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A PowerShell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Set/organisationchecklists
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
	[OutputType([Object])]
	[Alias('snoocl')]
	[MetadataAttribute(
		'/v2/organization/checklists',
		'put'
	)]
	param(
		[Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$checklists
	)
	process { try { if($PSCmdlet.ShouldProcess('Organisation Checklists','Update')){ return (New-NinjaOnePUTRequest -Resource 'v2/organization/checklists' -Body $checklists) } } catch { New-NinjaOneError -ErrorRecord $_ } }
}










