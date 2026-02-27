function New-NinjaOneWindowsEventPolicyCondition {
	<#
		.SYNOPSIS
			Creates a new windows event policy condition using the NinjaOne API.
		.DESCRIPTION
			Create a new windows event policy condition using the NinjaOne v2 API.
		.FUNCTIONALITY
			Windows Event Policy Condition
		.EXAMPLE
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - BEGIN
			PS> $body = @{
				enabled = $false
				displayName = "string"
				severity = "NONE"
				priority = "NONE"
				channels = @(
					0
				)
				scripts = @(
					@{
						scriptId = 0
						runAs = "SYSTEM"
						scriptParam = "string"
						scriptVariables = @(
							@{
								id = "string"
								value = "string"
							}
						)
					}
				)
				notificationAction = "NONE"
				notifyOnReset = $false
				resetThreshold = 0
				source = "string"
				eventIds = @(
					0
				)
				text = @{
					values = @(
						"string"
					)
					condition = "CONTAINS"
					include = "ALL"
				}
				occurrence = @{
					enabled = $false
					threshold = 0
					duration = 0
				}
			}
			PS> New-NinjaOneWindowsEventPolicyCondition -windowsEventPolicyCondition $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/customfieldspolicycondition
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('nnocfpc')]
	[MetadataAttribute(
		'/v2/policies/{policy_id}/condition/windows-event',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The policy id to create the windows event policy condition for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$policyId,
		# An object containing the windows event policy condition to create.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$windowsEventPolicyCondition,
		# Show the windows event policy condition that was created.
		[Switch]$show
	)
	process {
		try {
			$Resource = ('v2/policies/{0}/condition/windows-event' -f $policyId)
			$RequestParams = @{
				Resource = $Resource
				Body = $windowsEventPolicyCondition
			}
			if ($PSCmdlet.ShouldProcess(('Windows Event condition for policy {0}' -f $policyId), 'Create')) {
				$WindowsEventConditionCreate = New-NinjaOnePOSTRequest @RequestParams
				if ($show) {
					return $WindowsEventConditionCreate
				} else {
					Write-Information ('Windows Event conditon {0} created.' -f $WindowsEventConditionCreate.displayName)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}









