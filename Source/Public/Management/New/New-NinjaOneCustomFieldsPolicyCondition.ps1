function New-NinjaOneCustomFieldsPolicyCondition {
	<#
		.SYNOPSIS
			Creates a new custom fields policy condition using the NinjaOne API.
		.DESCRIPTION
			Create a new custom fields policy condition using the NinjaOne v2 API.
		.FUNCTIONALITY
			Custom Fields Policy Condition
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
				matchAll = @(
					@{
						fieldName = "string"
						operator = "EQUALS"
						value = "string"
					}
				)
				matchAny = @(
					@{
					}
				)
			}
			PS> New-NinjaOneCustomFieldsPolicyCondition -customFieldsPolicyCondition $body
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
		'/v2/policies/{policy_id}/condition/custom-fields',
		'post'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The policy id to create the custom fields policy condition for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$policyId,
		# An object containing the custom fields policy condition to create.
		[Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
		[Alias('body')]
		[Object]$customFieldsPolicyCondition,
		# Show the custom fields policy condition that was created.
		[Switch]$show
	)
	process {
		try {
			$Resource = ('v2/policies/{0}/condition/custom-fields' -f $policyId)
			$RequestParams = @{
				Resource = $Resource
				Body = $customFieldsPolicyCondition
			}
			if ($PSCmdlet.ShouldProcess(('Custom Fields condition for policy {0}' -f $policyId), 'Create')) {
				$CustomFieldsConditionCreate = New-NinjaOnePOSTRequest @RequestParams
				if ($show) {
					return $CustomFieldsConditionCreate
				} else {
					Write-Information ('Custom Fields condition {0} created.' -f $CustomFieldsConditionCreate.displayName)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}









