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
				notifyOnReset = $false
				resetThreshold = 0
				matchAny = @(
					@{
						fieldName = "string"
						operator = "EQUALS"
						value = "string"
					}
				)
				priority = "NONE"
				notificationAction = "NONE"
				channels = @(
					0
				)
				severity = "NONE"
				scripts = @(
					@{
						scriptId = 0
						scriptParam = "string"
						scriptVariables = @(
							@{
								value = "string"
								id = "string"
							}
						)
						runAs = "SYSTEM"
					}
				)
				matchAll = @(
					@{
						fieldName = "string"
						operator = "EQUALS"
						value = "string"
					}
				)
			}
			PS> New-NinjaOneCustomFieldsPolicyCondition -policyId <value> -customFieldsPolicyCondition $body
			# FULL REQUEST EXAMPLE (AUTO-GENERATED) - END
			
			Full request example (auto-generated).
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/New/customfieldspolicycondition`n`t#>
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





