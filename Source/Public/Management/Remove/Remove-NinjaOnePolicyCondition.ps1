function Remove-NinjaOnePolicyCondition {
	<#
		.SYNOPSIS
			Remove the given policy condition.
		.DESCRIPTION
			Removes the given policy condition using the NinjaOne v2 API.
		.FUNCTIONALITY
			Policy Condition
		.OUTPUTS
			A powershell object containing the response.
		.LINK
			https://docs.homotechsual.dev/modules/ninjaone/commandlets/Remove/policycondition
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	[OutputType([Object])]
	[Alias('rnopc')]
	[MetadataAttribute(
		'/v2/policies/{policy_id}/condition/{condition_id}',
		'delete'
	)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Uses dynamic parameter parsing.')]
	param(
		# The policy id to remove the condition from.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[Alias('id')]
		[Int]$policyId,
		# The condition id to remove.
		[Parameter(Mandatory, Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[GUID]$conditionId
	)
	process {
		try {
			$Resource = ('v2/policies/{0}/condition/{1}' -f $policyId, $conditionId)
			$RequestParams = @{
				Resource = $Resource
			}
			if ($PSCmdlet.ShouldProcess(('Policy {0} Condition {1}' -f $policyId, $conditionId), 'Delete')) {
				$PolicyConditionDelete = New-NinjaOneDELETERequest @RequestParams
				if ($PolicyConditionDelete -eq 204) {
					Write-Information ('Condition {0} in policy with id {1} deleted successfully.' -f $conditionId, $policyId)
				}
			}
		} catch {
			New-NinjaOneError -ErrorRecord $_
		}
	}
}
