function New-NinjaOneCustomFieldsPolicyCondition {
	<#
		.SYNOPSIS
			Creates a new custom fields policy condition using the NinjaOne API.
		.DESCRIPTION
			Create a new custom fields policy condition using the NinjaOne v2 API.
		.FUNCTIONALITY
			Custom Fields Policy Condition
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
	Param(
		# The policy id to create the custom fields policy condition for.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id', 'policyId')]
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
					$OIP = $InformationPreference
					$InformationPreference = 'Continue'
					Write-Information ('Custom Fields condition {0} created.' -f $CustomFieldsConditionCreate.displayName)
					$InformationPreference = $OIP
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}