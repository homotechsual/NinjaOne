function New-NinjaOneOrganisationChecklist {
	<#
		.SYNOPSIS
			Creates an organisation checklist.
		.DESCRIPTION
			Creates a new organisation checklist via the NinjaOne v2 API.
		.FUNCTIONALITY
			Organisation Checklists
		.EXAMPLE
			PS> New-NinjaOneOrganisationChecklist -checklist @{ name = 'Onboarding'; items = @('Step1','Step2') }

			Creates an organisation checklist.
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @(
				@{
					name = "string"
					description = @{
						text = "string"
						html = "string"
					}
					required = $false
					dueDate = 0
					assignedToUserId = 0
					organizationId = 0
					checklistTemplateId = 0
					tasks = @(
						@{
							id = 0
							position = 0
							name = "string"
							description = @{
							}
							assignedToUserId = 0
							dueDate = 0
							completed = $false
						}
					)
				}
			)
			PS> New-NinjaOneOrganisationChecklist -checklist $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A PowerShell object containing the created checklist.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/organisationchecklist
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnoocl')]
	[MetadataAttribute(
		'/v2/organization/checklists',
		'post'
	)]
	param(
		# Checklist payload per API schema
		[Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$checklist
	)
	process {
		try {
			$Resource = 'v2/organization/checklists'
			$RequestParams = @{ Resource = $Resource; Body = $checklist }
			if ($PSCmdlet.ShouldProcess('Organisation checklist', 'Create')) {
				$Result = New-NinjaOnePOSTRequest @RequestParams
				return $Result
			}
		} catch { New-NinjaOneError -ErrorRecord $_ }
	}
}










